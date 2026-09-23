import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useMutation } from '@tanstack/react-query';
import { scanFromURLAsync } from 'expo-camera';
import * as ImagePicker from 'expo-image-picker';

import {
  BottomSheet,
  Button,
  Card,
  coreColors,
  GradientHeader,
  spacing,
  TextField,
  textStyles,
  Toast,
  useUiTheme,
} from '@neast/ui-mobile';

import manualIcon from '../../../assets/images/scan/manual.png';
import photosIcon from '../../../assets/images/scan/photos.png';

import { apiErrorMessage } from '../../lib/api';
import { openRedeemVoucher, openScanner } from '../../lib/callbacks';
import { verifyCoupon } from '../../lib/endpoints';
import { useMerchantInfo } from '../../hooks/use-merchant';

/**
 * Scan tab (scan_screen parity): tap-to-scan frame, manual 6-char voucher
 * entry, gallery QR pick, outlet info card. Any code — scanned or manual —
 * goes to POST /merchant/coupon/verify, then /redeem-voucher.
 */
export function ScanTab() {
  const theme = useUiTheme();
  const info = useMerchantInfo();
  const [manualVisible, setManualVisible] = useState(false);
  const [manualCode, setManualCode] = useState('');
  const [manualError, setManualError] = useState<string | undefined>(undefined);

  const verifyMutation = useMutation({
    mutationFn: (code: string) => verifyCoupon(code),
    onSuccess: (preview, code) => openRedeemVoucher({ preview, code }),
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const handleCode = (code: string) => {
    verifyMutation.mutate(code);
  };

  const submitManual = () => {
    if (!/^[A-Z0-9]{6}$/.test(manualCode)) {
      setManualError('Enter the 6-character voucher code');
      return;
    }
    setManualVisible(false);
    handleCode(manualCode);
    setManualCode('');
    setManualError(undefined);
  };

  const pickFromGallery = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({ mediaTypes: ['images'] });
    const asset = result.canceled ? null : (result.assets[0] ?? null);
    if (!asset) {
      return;
    }
    try {
      const scanned = await scanFromURLAsync(asset.uri, ['qr']);
      const value = scanned[0]?.data;
      if (value) {
        handleCode(value);
      } else {
        Toast.error('No QR code found in the image');
      }
    } catch {
      Toast.error('No QR code found in the image');
    }
  };

  return (
    <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scroll}>
        <GradientHeader colors={theme.gradients.header} style={styles.header}>
          <Text style={styles.headerTitle}>Scan</Text>
          <Text style={styles.headerSubtitle}>Scan a voucher QR to redeem</Text>
        </GradientHeader>

        <Pressable
          style={styles.scanFrame}
          onPress={() => openScanner(handleCode)}
          disabled={verifyMutation.isPending}
          accessibilityRole="button"
          accessibilityLabel="Open QR scanner"
        >
          <View style={styles.scanFrameInner}>
            <Text style={styles.scanFrameText}>
              {verifyMutation.isPending ? 'Verifying…' : 'Tap to scan'}
            </Text>
          </View>
        </Pressable>

        <View style={styles.actions}>
          <Pressable
            style={styles.action}
            onPress={() => setManualVisible(true)}
            accessibilityRole="button"
          >
            <Image source={manualIcon} style={styles.actionIcon} />
            <Text style={styles.actionLabel}>Manual</Text>
          </Pressable>
          <Pressable
            style={styles.action}
            onPress={() => {
              void pickFromGallery();
            }}
            accessibilityRole="button"
          >
            <Image source={photosIcon} style={styles.actionIcon} />
            <Text style={styles.actionLabel}>Photos</Text>
          </Pressable>
        </View>

        <Card style={styles.outletCard}>
          <Text style={styles.outletLabel}>Outlet</Text>
          <Text style={styles.outletName}>{info.data?.name ?? ''}</Text>
          {info.data?.address ? (
            <Text style={styles.outletAddress}>{info.data.address}</Text>
          ) : null}
        </Card>
      </ScrollView>

      <BottomSheet
        visible={manualVisible}
        onClose={() => setManualVisible(false)}
        title="Enter voucher code"
      >
        <View style={styles.manualForm}>
          <TextField
            value={manualCode}
            onChangeText={(value) => {
              setManualCode(value.toUpperCase());
              setManualError(undefined);
            }}
            placeholder="e.g. A1B2C3"
            autoCapitalize="characters"
            autoCorrect={false}
            maxLength={6}
            error={manualError}
          />
          <Button title="Verify" onPress={submitManual} loading={verifyMutation.isPending} />
        </View>
      </BottomSheet>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  scroll: {
    paddingBottom: spacing.xl,
  },
  header: {
    alignItems: 'center',
    paddingBottom: spacing.xxl,
  },
  headerTitle: {
    ...textStyles.heading1,
    color: coreColors.white,
    marginTop: spacing.lg,
  },
  headerSubtitle: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    opacity: 0.85,
    marginTop: spacing.xs,
  },
  scanFrame: {
    alignSelf: 'center',
    width: 240,
    height: 240,
    marginTop: -spacing.xl,
    borderRadius: 16,
    borderWidth: 2,
    borderColor: coreColors.brandBlueLight,
    backgroundColor: coreColors.tintBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scanFrameInner: {
    alignItems: 'center',
  },
  scanFrameText: {
    ...textStyles.body,
    color: coreColors.brandBlueLight,
    fontWeight: '600',
  },
  actions: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: spacing.xl,
    marginTop: spacing.xl,
  },
  action: {
    alignItems: 'center',
    gap: spacing.sm,
  },
  actionIcon: {
    width: 48,
    height: 48,
  },
  actionLabel: {
    ...textStyles.bodySmall,
    color: coreColors.blackText,
  },
  outletCard: {
    marginHorizontal: spacing.lg,
    marginTop: spacing.xl,
  },
  outletLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  outletName: {
    ...textStyles.heading3,
    marginTop: spacing.xs,
  },
  outletAddress: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.xs,
  },
  manualForm: {
    gap: spacing.md,
  },
});
