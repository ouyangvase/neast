import * as ImagePicker from 'expo-image-picker';

import type { UploadFileInput } from '@neast/types';

/** property_file_picker parity: image from the gallery… */
export async function pickImageFile(): Promise<UploadFileInput | null> {
  const result = await ImagePicker.launchImageLibraryAsync({
    mediaTypes: ['images'],
    quality: 0.85,
  });
  const asset = result.canceled ? null : (result.assets[0] ?? null);
  if (!asset) {
    return null;
  }
  return {
    uri: asset.uri,
    name: asset.fileName ?? `photo-${Date.now()}.jpg`,
    type: asset.mimeType ?? 'image/jpeg',
    size: asset.fileSize,
  };
}
