import { router } from 'expo-router';

import { QrScannerScreen } from '@neast/ui-mobile';

import { handleScanned } from '@/lib/callbacks';

/**
 * QR scanner (qr_scanner_screen parity). Callers use `openScanner(cb)`;
 * the scanned value is delivered to the callback, then we pop.
 */
export default function ScannerRoute() {
  return (
    <QrScannerScreen
      onScanned={(value) => {
        handleScanned(value);
        router.back();
      }}
      onClose={() => router.back()}
    />
  );
}
