import { api } from './api';

/** Resolve an uploaded file path to a displayable URL (rent_file_actions.dart parity). */
export function resolveFileUrl(file: string | null | undefined, fileUrl?: string | null): string {
  if (fileUrl) {
    return fileUrl;
  }
  if (!file) {
    return '';
  }
  if (/^https?:\/\//i.test(file)) {
    return file;
  }
  return `${api.baseUrl}/${file.replace(/^\/+/, '')}`;
}

/** Image files open in the in-app preview; anything else opens externally. */
export function isImagePath(path: string): boolean {
  return /\.(png|jpe?g|gif|webp|bmp|heic)(\?.*)?$/i.test(path);
}
