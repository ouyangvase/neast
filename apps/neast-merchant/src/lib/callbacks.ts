import { router } from 'expo-router';

import type { VerifyCouponResponse } from '@neast/types';
import type { FiuuPaymentResult } from '@neast/ui-mobile';

/**
 * Screen-result callbacks + route args. The Flutter app pops routes with a
 * result value (`/scanner` → scanned string, `/pay-h5-webview` → Fiuu result)
 * and pushes routes with an `extra` payload; Expo Router has neither, so
 * callers stash values here before pushing and the pushed screen reads them.
 */

// ---- QR scanner ----

let scannerCallback: ((value: string) => void) | null = null;

export function openScanner(onScanned: (value: string) => void): void {
  scannerCallback = onScanned;
  router.push('/scanner');
}

/** Called by the scanner route once a value is scanned. */
export function handleScanned(value: string): void {
  const callback = scannerCallback;
  scannerCallback = null;
  callback?.(value);
}

// ---- Fiuu H5 WebView ----

export interface H5Callbacks {
  onResult: (result: FiuuPaymentResult) => void;
  onCancel?: () => void;
}

let h5Callbacks: H5Callbacks | null = null;

export function openH5WebView(url: string, title: string, callbacks: H5Callbacks): void {
  h5Callbacks = callbacks;
  router.push({ pathname: '/pay-h5-webview', params: { url, title } });
}

export function getH5Callbacks(): H5Callbacks | null {
  return h5Callbacks;
}

export function clearH5Callbacks(): void {
  h5Callbacks = null;
}

// ---- /redeem-coupon ----

export interface RedeemCouponArgs {
  preview: VerifyCouponResponse;
  code: string;
}

let redeemCouponArgs: RedeemCouponArgs | null = null;

export function openRedeemCoupon(args: RedeemCouponArgs): void {
  redeemCouponArgs = args;
  router.push('/redeem-coupon');
}

export function getRedeemCouponArgs(): RedeemCouponArgs | null {
  return redeemCouponArgs;
}

// ---- /give-points/receipt-details (ReceiptCaptureResult parity) ----

/** A captured receipt: compressed locally, already uploaded via /merchant/upload/*. */
export interface ReceiptCaptureResult {
  /** Local (compressed) image URI — display only. */
  uri: string;
  /** Server path from the upload — sent as `receipt_path` on confirm. */
  path: string;
  name: string;
}

let receiptCapture: ReceiptCaptureResult | null = null;

export function openReceiptDetails(receipt: ReceiptCaptureResult): void {
  receiptCapture = receipt;
  router.push('/give-points/receipt-details');
}

export function getReceiptCapture(): ReceiptCaptureResult | null {
  return receiptCapture;
}

// ---- /give-points/confirm-points (ReceiptConfirmPayload parity) ----

export interface ConfirmPointsArgs {
  receiptPath: string;
  receiptNumber: string;
  amount: string;
  points: number;
  notes: string;
}

let confirmPointsArgs: ConfirmPointsArgs | null = null;

export function openConfirmPoints(args: ConfirmPointsArgs): void {
  confirmPointsArgs = args;
  router.push('/give-points/confirm-points');
}

export function getConfirmPointsArgs(): ConfirmPointsArgs | null {
  return confirmPointsArgs;
}
