import { CameraView, useCameraPermissions } from 'expo-camera';
import { useEffect, useRef } from 'react';
import { Animated, Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Button } from './Button';
import { Chevron } from './Chevron';

export interface QrScannerScreenProps {
  /** Called once with the raw scanned string (returned via navigation pop by callers). */
  onScanned: (value: string) => void;
  /** Close / back handler. */
  onClose?: () => void;
  title?: string;
}

/**
 * Full-screen QR scanner (mobile_scanner equivalent) with the animated
 * scan-line frame overlay. Fires `onScanned` once per mount.
 */
export function QrScannerScreen({
  onScanned,
  onClose,
  title = 'Scan QR Code',
}: QrScannerScreenProps) {
  const insets = useSafeAreaInsets();
  const [permission, requestPermission] = useCameraPermissions();
  const scannedRef = useRef(false);
  const scanLine = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(scanLine, { toValue: 1, duration: 1800, useNativeDriver: true }),
        Animated.timing(scanLine, { toValue: 0, duration: 1800, useNativeDriver: true }),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [scanLine]);

  const handleBarcodeScanned = ({ data }: { data: string }) => {
    if (scannedRef.current) return;
    scannedRef.current = true;
    onScanned(data);
  };

  if (!permission) {
    return <View style={styles.container} />;
  }

  if (!permission.granted) {
    return (
      <View style={[styles.container, styles.centered]}>
        <Text style={styles.permissionText}>Camera access is required to scan QR codes.</Text>
        <Button
          title="Grant permission"
          onPress={() => {
            void requestPermission();
          }}
          fullWidth={false}
        />
        {onClose ? (
          <Button title="Back" variant="ghost" onPress={onClose} fullWidth={false} />
        ) : null}
      </View>
    );
  }

  const lineTranslate = scanLine.interpolate({
    inputRange: [0, 1],
    outputRange: [0, FRAME_SIZE - 2],
  });

  return (
    <View style={styles.container}>
      <CameraView
        style={StyleSheet.absoluteFill}
        facing="back"
        barcodeScannerSettings={{ barcodeTypes: ['qr'] }}
        onBarcodeScanned={handleBarcodeScanned}
      />
      <View style={styles.overlay} pointerEvents="none">
        <View style={styles.frame}>
          <Animated.View
            style={[styles.scanLine, { transform: [{ translateY: lineTranslate }] }]}
          />
        </View>
      </View>
      <View style={[styles.header, { top: insets.top + spacing.md }]}>
        {onClose ? (
          <Pressable
            onPress={onClose}
            accessibilityRole="button"
            accessibilityLabel="Back"
            hitSlop={12}
            style={styles.back}
          >
            <Chevron direction="left" color={coreColors.white} />
          </Pressable>
        ) : null}
        <Text style={styles.title}>{title}</Text>
      </View>
    </View>
  );
}

const FRAME_SIZE = 240;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.black,
  },
  centered: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
    gap: spacing.md,
  },
  permissionText: {
    ...textStyles.body,
    color: coreColors.white,
    textAlign: 'center',
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  frame: {
    width: FRAME_SIZE,
    height: FRAME_SIZE,
    borderWidth: 2,
    borderColor: coreColors.white,
    borderRadius: radii.card,
    overflow: 'hidden',
  },
  scanLine: {
    height: 2,
    backgroundColor: '#22D3EE',
  },
  header: {
    position: 'absolute',
    left: 0,
    right: 0,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  back: {
    position: 'absolute',
    left: spacing.lg,
    padding: spacing.xs,
  },
  title: {
    ...textStyles.heading3,
    color: coreColors.white,
  },
});
