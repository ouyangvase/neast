import { useRef, useState } from 'react';

import { UploadCancelledError, type UploadFileInput } from '@neast/types';
import { Toast } from '@neast/ui-mobile';

import { api, apiErrorMessage } from '@/lib/api';

/**
 * Chunked-upload driver (uploadServiceProvider + upload_progress_dialog
 * parity). Returns the uploaded `path` for form bodies, or null on
 * cancel/failure (a toast is shown either way).
 */
export function useFileUpload() {
  const [progress, setProgress] = useState<number | null>(null);
  const [fileName, setFileName] = useState<string | undefined>(undefined);
  const abortRef = useRef<AbortController | null>(null);

  const upload = async (input: UploadFileInput): Promise<string | null> => {
    const controller = new AbortController();
    abortRef.current = controller;
    setFileName(input.name);
    setProgress(0);
    try {
      const result = await api.uploadFile(input, {
        signal: controller.signal,
        onProgress: (p) => {
          setProgress(p.totalBytes > 0 ? p.loadedBytes / p.totalBytes : 0);
        },
      });
      return result.path;
    } catch (error) {
      if (error instanceof UploadCancelledError) {
        Toast.show('Upload cancelled');
      } else {
        Toast.error(apiErrorMessage(error, 'Upload failed. Please try again.'));
      }
      return null;
    } finally {
      setProgress(null);
      setFileName(undefined);
      abortRef.current = null;
    }
  };

  const cancel = () => abortRef.current?.abort();

  return { upload, progress, fileName, cancel };
}
