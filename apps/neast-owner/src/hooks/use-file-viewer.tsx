import { useState } from 'react';
import { Linking } from 'react-native';

import { ImagePreview, Toast } from '@neast/ui-mobile';

function isImagePath(path: string): boolean {
  return /\.(png|jpe?g|gif|webp|bmp|heic)(\?.*)?$/i.test(path);
}

/**
 * Agreement-file opener (property_file_actions / rent_detail parity): images
 * open in the in-app preview, anything else opens externally. `file_url`
 * arrives absolute from the backend.
 */
export function useFileViewer() {
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);

  const open = (url: string) => {
    if (!url) {
      Toast.error('No agreement uploaded');
      return;
    }
    if (isImagePath(url)) {
      setPreviewUrl(url);
    } else {
      void Linking.openURL(url);
    }
  };

  const preview = previewUrl ? (
    <ImagePreview
      visible
      source={{ uri: previewUrl }}
      onClose={() => setPreviewUrl(null)}
      caption="Tenancy agreement"
    />
  ) : null;

  return { open, preview };
}
