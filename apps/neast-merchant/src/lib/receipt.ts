import * as ImageManipulator from 'expo-image-manipulator';
import * as ImagePicker from 'expo-image-picker';

import type { UploadFileInput } from '@neast/types';
import { Toast } from '@neast/ui-mobile';

/**
 * Receipt capture (receipt_capture_service.dart parity). The Flutter primary
 * (cunning_document_scanner) has no Expo SDK equivalent, so the documented
 * fallback — camera / gallery via image_picker — is the path here.
 */
export interface CapturedReceipt extends UploadFileInput {
  width: number;
  height: number;
}

function toInput(result: ImagePicker.ImagePickerResult): CapturedReceipt | null {
  const asset = result.canceled ? null : (result.assets[0] ?? null);
  if (!asset) {
    return null;
  }
  return {
    uri: asset.uri,
    name: asset.fileName ?? `receipt-${Date.now()}.jpg`,
    type: asset.mimeType ?? 'image/jpeg',
    size: asset.fileSize,
    width: asset.width,
    height: asset.height,
  };
}

/** Camera capture (full quality — compression happens in compressReceipt). */
export async function captureReceiptFromCamera(): Promise<CapturedReceipt | null> {
  const permission = await ImagePicker.requestCameraPermissionsAsync();
  if (!permission.granted) {
    Toast.error('Camera access is required to capture a receipt.');
    return null;
  }
  return toInput(await ImagePicker.launchCameraAsync({ quality: 1 }));
}

/** Gallery pick (full quality — compression happens in compressReceipt). */
export async function pickReceiptFromLibrary(): Promise<CapturedReceipt | null> {
  return toInput(await ImagePicker.launchImageLibraryAsync({ mediaTypes: ['images'], quality: 1 }));
}

/**
 * image_compress_util.dart parity: skip files under 512KB; otherwise resize
 * the longest side to 1920 and re-encode as JPEG at quality 85.
 */
export async function compressReceipt(file: CapturedReceipt): Promise<UploadFileInput> {
  if (file.size !== undefined && file.size < 512 * 1024) {
    return file;
  }
  const context = ImageManipulator.ImageManipulator.manipulate(file.uri);
  if (Math.max(file.width, file.height) > 1920) {
    context.resize(file.width >= file.height ? { width: 1920 } : { height: 1920 });
  }
  const rendered = await context.renderAsync();
  const result = await rendered.saveAsync({
    compress: 0.85,
    format: ImageManipulator.SaveFormat.JPEG,
  });
  return { uri: result.uri, name: file.name, type: 'image/jpeg' };
}
