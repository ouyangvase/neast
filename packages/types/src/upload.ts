import { ApiError } from './envelope';
import type { UploadFileResult } from './contracts/common';
import type { ApiClient, ApiPrefix } from './client';

export interface UploadFileInput {
  /** Local file URI (`file://…`, `content://…`, ImagePicker asset uri). */
  uri: string;
  /** Original filename, sent as the `filename` form field. */
  name: string;
  /** MIME type for the direct-upload form part (defaults to application/octet-stream). */
  type?: string;
  /** Byte size when known (ImagePicker `fileSize`). Skips the size probe when provided. */
  size?: number;
}

export interface UploadProgress {
  loadedBytes: number;
  totalBytes: number;
  uploadedChunks: number;
  totalChunks: number;
}

export interface UploadOptions {
  /** AbortSignal cancels in-flight chunks and rejects with `UploadCancelledError`. */
  signal?: AbortSignal;
  onProgress?: (progress: UploadProgress) => void;
  /** Override the profile's chunk size (bytes). */
  chunkSizeBytes?: number;
  /** Override the profile's parallel chunk workers. */
  concurrency?: number;
}

export interface UploadProfile {
  chunkSizeBytes: number;
  concurrency: number;
}

/**
 * Chunking profiles per app (legacy parity with the Flutter upload services):
 * user + owner upload rent agreements in 512KB chunks with 4 workers; the
 * merchant app uploads receipts in 256KB chunks with 8 workers.
 */
export const UPLOAD_PROFILES: Readonly<Record<ApiPrefix, UploadProfile>> = {
  '/app': { chunkSizeBytes: 512 * 1024, concurrency: 4 },
  '/landlord': { chunkSizeBytes: 512 * 1024, concurrency: 4 },
  '/merchant': { chunkSizeBytes: 256 * 1024, concurrency: 8 },
};

/** Backend limits (UploadController): 10MB per file, ≤ 100 chunks. */
export const UPLOAD_MAX_FILE_BYTES = 10 * 1024 * 1024;
export const UPLOAD_MAX_CHUNKS = 100;

export class UploadCancelledError extends ApiError {
  constructor() {
    super(0, 'Upload cancelled', 'cancelled');
    this.name = 'UploadCancelledError';
  }
}

function randomHex(length: number): string {
  let out = '';
  for (let i = 0; i < length; i += 1) {
    out += Math.floor(Math.random() * 16).toString(16);
  }
  return out;
}

/** Matches the backend's `^[a-zA-Z0-9_\-]{8,64}$` upload-id rule. */
function generateUploadId(): string {
  return `${Date.now()}_${randomHex(6)}`;
}

/**
 * Upload a file through `{prefix}/upload/*`.
 *
 * Files that fit in one chunk go straight to `upload/file`; larger files are
 * sliced into `upload/chunk` parts (parallel workers, per-part retry of the
 * 400-refresh flow handled by the client) and finalized with `upload/merge`.
 */
export async function uploadFile(
  client: ApiClient,
  file: UploadFileInput,
  options: UploadOptions = {},
): Promise<UploadFileResult> {
  const profile = UPLOAD_PROFILES[client.prefix];
  const chunkSize = options.chunkSizeBytes ?? profile.chunkSizeBytes;
  const concurrency = Math.max(1, options.concurrency ?? profile.concurrency);
  const { signal } = options;

  const throwIfAborted = () => {
    if (signal?.aborted) {
      throw new UploadCancelledError();
    }
  };
  throwIfAborted();

  if (file.size !== undefined && file.size > UPLOAD_MAX_FILE_BYTES) {
    throw new ApiError(0, 'File exceeds the 10MB upload limit', 'business');
  }

  // Small file (or unknown size): single multipart POST, no chunking.
  if (file.size !== undefined && file.size <= chunkSize) {
    return client.uploadMultipart<UploadFileResult>('upload/file', {
      fileField: 'file',
      file,
      filename: file.name,
      signal,
      onProgress: (loadedBytes, totalBytes) => {
        options.onProgress?.({
          loadedBytes,
          totalBytes,
          uploadedChunks: loadedBytes >= totalBytes ? 1 : 0,
          totalChunks: 1,
        });
      },
    });
  }

  // Resolve the local file into a Blob so it can be sliced into chunks.
  let blob: Blob;
  try {
    const response = await fetch(file.uri);
    blob = await response.blob();
  } catch (error) {
    if (signal?.aborted) {
      throw new UploadCancelledError();
    }
    throw new ApiError(0, 'Failed to read the local file', 'network', undefined, {
      cause: error,
    });
  }
  throwIfAborted();

  const totalBytes = blob.size;
  if (totalBytes > UPLOAD_MAX_FILE_BYTES) {
    throw new ApiError(0, 'File exceeds the 10MB upload limit', 'business');
  }
  const totalChunks = Math.max(1, Math.ceil(totalBytes / chunkSize));
  if (totalChunks > UPLOAD_MAX_CHUNKS) {
    throw new ApiError(0, 'File exceeds the 100-chunk upload limit', 'business');
  }

  const uploadId = generateUploadId();
  let nextIndex = 0;
  let loadedBytes = 0;
  let uploadedChunks = 0;
  const report = () => {
    options.onProgress?.({ loadedBytes, totalBytes, uploadedChunks, totalChunks });
  };
  report();

  const worker = async (): Promise<void> => {
    for (;;) {
      throwIfAborted();
      const index = nextIndex;
      nextIndex += 1;
      if (index >= totalChunks) {
        return;
      }
      const start = index * chunkSize;
      const chunk = blob.slice(start, Math.min(start + chunkSize, totalBytes));
      await client.uploadMultipart('upload/chunk', {
        fileField: 'file',
        file: chunk,
        filename: file.name,
        signal,
        fields: {
          upload_id: uploadId,
          chunk_index: index,
          total_chunks: totalChunks,
          filename: file.name,
        },
      });
      loadedBytes += chunk.size;
      uploadedChunks += 1;
      report();
    }
  };

  try {
    const workers: Promise<void>[] = [];
    for (let i = 0; i < Math.min(concurrency, totalChunks); i += 1) {
      workers.push(worker());
    }
    await Promise.all(workers);
    return await client.post<UploadFileResult>(
      'upload/merge',
      { upload_id: uploadId, filename: file.name, total_chunks: totalChunks },
      { signal },
    );
  } catch (error) {
    if (signal?.aborted || (error instanceof ApiError && error.kind === 'cancelled')) {
      throw new UploadCancelledError();
    }
    throw error;
  }
}
