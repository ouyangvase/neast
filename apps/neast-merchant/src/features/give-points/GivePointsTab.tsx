import { useState } from 'react';
import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatRinggit, formatThousands, useIsLoggedIn } from '@neast/types';
import {
  BottomSheet,
  Button,
  Card,
  Chevron,
  coreColors,
  spacing,
  textStyles,
  UploadProgressDialog,
} from '@neast/ui-mobile';

import headerImage from '@assets/images/give_points/header.png';
import CameraIcon from '@assets/images/give_points/camera.svg';
import ruleIcon from '@assets/images/give_points/rule-icon.png';
import stat1Icon from '@assets/images/give_points/stat1.png';
import stat2Icon from '@assets/images/give_points/stat2.png';
import stat3Icon from '@assets/images/give_points/stat3.png';
import stat4Icon from '@assets/images/give_points/stat4.png';

import { Screen } from '@/components/Screen';
import { openReceiptDetails, type ReceiptCaptureResult } from '@/lib/callbacks';
import {
  getGivePointsStats,
  getPointsSetting,
  getTodayCommission,
} from '@/lib/endpoints';
import {
  captureReceiptFromCamera,
  compressReceipt,
  pickReceiptFromLibrary,
  type CapturedReceipt,
} from '@/lib/receipt';
import { useMerchantInfo } from '@/hooks/use-merchant';
import { useFileUpload } from '@/hooks/use-upload';

/**
 * Give Points tab (give_points_screen parity): header, today stats card,
 * receipt capture card, earn-rule card, outlet card → /daily-closing.
 */
export function GivePointsTab() {
  const isLoggedIn = useIsLoggedIn();
  const info = useMerchantInfo();
  const [captureSheetVisible, setCaptureSheetVisible] = useState(false);
  const { upload, progress, fileName, cancel } = useFileUpload();

  const commission = useQuery({
    queryKey: ['give-points', 'today-commission'],
    queryFn: getTodayCommission,
    enabled: isLoggedIn,
  });
  const stats = useQuery({
    queryKey: ['give-points', 'stats'],
    queryFn: getGivePointsStats,
    enabled: isLoggedIn,
  });
  const pointsSetting = useQuery({
    queryKey: ['points-setting'],
    queryFn: getPointsSetting,
    enabled: isLoggedIn,
  });

  // Capture → compress → chunked upload → /give-points/receipt-details.
  const handleCaptured = async (file: CapturedReceipt | null) => {
    if (!file) {
      return;
    }
    const compressed = await compressReceipt(file);
    const path = await upload(compressed);
    if (path) {
      const receipt: ReceiptCaptureResult = { uri: compressed.uri, path, name: compressed.name };
      openReceiptDetails(receipt);
    }
  };

  const pick = async (source: 'camera' | 'library') => {
    setCaptureSheetVisible(false);
    const file =
      source === 'camera' ? await captureReceiptFromCamera() : await pickReceiptFromLibrary();
    await handleCaptured(file);
  };

  return (
    <Screen>
      <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scroll}>
        <Image source={headerImage} style={styles.header} resizeMode="cover" />

        <Card style={styles.statsCard}>
          <View style={styles.commissionRow}>
            <View>
              <Text style={styles.commissionLabel}>Today's commission</Text>
              <Text style={styles.commissionValue}>
                {commission.data ? formatRinggit(commission.data.commission_rm) : '—'}
              </Text>
            </View>
            <View style={styles.commissionPoints}>
              <Text style={styles.commissionPointsValue}>
                {commission.data ? formatThousands(commission.data.points) : '—'}
              </Text>
              <Text style={styles.commissionPointsLabel}>points given</Text>
            </View>
          </View>
          <View style={styles.statGrid}>
            <StatCell
              icon={stat1Icon}
              label="Customers today"
              value={stats.data ? String(stats.data.customers_today) : '—'}
            />
            <StatCell
              icon={stat2Icon}
              label="Points today"
              value={stats.data ? formatThousands(stats.data.points_today) : '—'}
            />
            <StatCell
              icon={stat3Icon}
              label="Avg spend"
              value={stats.data ? formatRinggit(stats.data.avg_spend) : '—'}
            />
            <StatCell
              icon={stat4Icon}
              label="Repeat customers"
              value={stats.data ? String(stats.data.repeat_customers) : '—'}
            />
          </View>
        </Card>

        <Card style={styles.receiptCard} onPress={() => setCaptureSheetVisible(true)}>
          <View style={styles.receiptRow}>
            <View style={styles.receiptIconWrap}>
              <CameraIcon width={24} height={24} />
            </View>
            <View style={styles.receiptTexts}>
              <Text style={styles.receiptTitle}>Snap a receipt</Text>
              <Text style={styles.receiptSubtitle}>Capture a receipt to give points</Text>
            </View>
            <Chevron direction="right" color={coreColors.textHint} />
          </View>
        </Card>

        <Card style={styles.ruleCard}>
          <Image source={ruleIcon} style={styles.ruleIcon} />
          <View style={styles.ruleTexts}>
            <Text style={styles.ruleTitle}>Earn rule</Text>
            <Text style={styles.ruleBody}>
              {pointsSetting.data
                ? `Customers earn ${pointsSetting.data.yuan_to_points} points for every RM1 spent`
                : '—'}
            </Text>
          </View>
        </Card>

        <Card style={styles.outletCard} onPress={() => router.push('/daily-closing')}>
          <View style={styles.outletRow}>
            <View style={styles.receiptTexts}>
              <Text style={styles.outletLabel}>Outlet</Text>
              <Text style={styles.outletName}>{info.data?.name ?? ''}</Text>
              {info.data?.address ? (
                <Text style={styles.outletAddress}>{info.data.address}</Text>
              ) : null}
            </View>
            <View style={styles.outletAction}>
              <Text style={styles.outletActionText}>Daily closing</Text>
              <Chevron direction="right" color={coreColors.brandBlueLight} />
            </View>
          </View>
        </Card>
      </ScrollView>

      <BottomSheet
        visible={captureSheetVisible}
        onClose={() => setCaptureSheetVisible(false)}
        title="Capture receipt"
      >
        <View style={styles.captureSheet}>
          <Button title="Take photo" onPress={() => void pick('camera')} />
          <Button
            title="Choose from library"
            variant="outline"
            onPress={() => void pick('library')}
          />
        </View>
      </BottomSheet>

      <UploadProgressDialog
        visible={progress !== null}
        progress={progress ?? 0}
        fileName={fileName}
        onCancel={cancel}
      />
      </View>
    </Screen>
  );
}

function StatCell({
  icon,
  label,
  value,
}: {
  icon: number;
  label: string;
  value: string;
}) {
  return (
    <View style={styles.statCell}>
      <Image source={icon} style={styles.statIcon} />
      <Text style={styles.statValue}>{value}</Text>
      <Text style={styles.statLabel}>{label}</Text>
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
    gap: spacing.md,
  },
  header: {
    width: '100%',
    height: 160,
  },
  statsCard: {
    marginHorizontal: spacing.lg,
    marginTop: -spacing.xl,
    gap: spacing.lg,
  },
  commissionRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  commissionLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  commissionValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: 2,
  },
  commissionPoints: {
    alignItems: 'flex-end',
  },
  commissionPointsValue: {
    ...textStyles.heading2,
    color: coreColors.darkGreen,
  },
  commissionPointsLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  statGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    rowGap: spacing.md,
  },
  statCell: {
    width: '50%',
    alignItems: 'flex-start',
    gap: 2,
  },
  statIcon: {
    width: 28,
    height: 28,
    marginBottom: 2,
  },
  statValue: {
    ...textStyles.heading3,
  },
  statLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  receiptCard: {
    marginHorizontal: spacing.lg,
  },
  receiptRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  receiptIconWrap: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: coreColors.tintBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  receiptTexts: {
    flex: 1,
  },
  receiptTitle: {
    ...textStyles.heading3,
  },
  receiptSubtitle: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  ruleCard: {
    marginHorizontal: spacing.lg,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  ruleIcon: {
    width: 36,
    height: 36,
  },
  ruleTexts: {
    flex: 1,
  },
  ruleTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  ruleBody: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  outletCard: {
    marginHorizontal: spacing.lg,
  },
  outletRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  outletLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  outletName: {
    ...textStyles.heading3,
    marginTop: 2,
  },
  outletAddress: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  outletAction: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  outletActionText: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlueLight,
    fontWeight: '600',
  },
  captureSheet: {
    gap: spacing.md,
  },
});
