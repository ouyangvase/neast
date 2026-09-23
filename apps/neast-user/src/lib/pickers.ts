import * as DocumentPicker from 'expo-document-picker';
import * as ImagePicker from 'expo-image-picker';

import type { UploadFileInput } from '@neast/types';
import { Toast } from '@neast/ui-mobile';

/** pay_rent_agreement_picker parity: image from the gallery… */
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
    name: asset.fileName ?? `agreement-${Date.now()}.jpg`,
    type: asset.mimeType ?? 'image/jpeg',
    size: asset.fileSize,
  };
}

/** …or any file via the document picker. */
export async function pickDocumentFile(): Promise<UploadFileInput | null> {
  try {
    const result = await DocumentPicker.getDocumentAsync({
      type: '*/*',
      copyToCacheDirectory: true,
    });
    const asset = result.canceled ? null : (result.assets[0] ?? null);
    if (!asset) {
      return null;
    }
    return {
      uri: asset.uri,
      name: asset.name,
      type: asset.mimeType ?? 'application/octet-stream',
      size: asset.size,
    };
  } catch {
    Toast.error('Could not open the file picker.');
    return null;
  }
}
