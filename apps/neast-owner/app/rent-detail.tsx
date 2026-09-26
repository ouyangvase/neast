import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import {
  BrandHeader,
  Card,
  coreColors,
  ownerAccentColors,
  spacing,
  StatusTag,
  textStyles,
} from '@neast/ui-mobile';

import { useFileViewer } from '@/hooks/use-file-viewer';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/**
 * Rent detail (rent_detail_screen parity): lease view for a home due/overdue
 * item. Data arrives via the selection store (go_router `extra` parity); the
 * Flutter hardcoded fallback dummy data is intentionally not ported.
 */
export default function RentDetailRoute() {
  const item = useSelectionStore((state) => state.dueItem);
  const fileViewer = useFileViewer();

  if (!item) {
    return (
      <Screen>
        <BrandHeader title="Rent Detail" onBack={() => router.back()} />
        <ErrorState message="Record unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  const overdue = item.status === 'overdue';

  return (
    <Screen>
      <BrandHeader title="Rent Detail" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.scroll}>
        <Card style={styles.card}>
          <View style={styles.titleRow}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.tenant_initials}</Text>
            </View>
            <View style={styles.titleTexts}>
              <Text style={styles.name} numberOfLines={1}>
                {item.tenant_name}
              </Text>
              <Text style={styles.unit} numberOfLines={1}>
                {item.unit_address}
              </Text>
            </View>
            <StatusTag
              label={item.status_text}
              status={overdue ? 'overdue' : 'pending'}
              color={overdue ? undefined : ownerAccentColors.orange}
              backgroundColor={overdue ? undefined : ownerAccentColors.gradientWarmStart}
            />
          </View>
          <Text style={styles.amount}>RM{item.amount}</Text>
          <View style={styles.infoRows}>
            <InfoRow label="Property" value={item.property_name || item.property_address} />
            <InfoRow label="Rental date" value={item.rental_date} />
          </View>
          <Pressable onPress={() => fileViewer.open(item.file_url)} accessibilityRole="button">
            <Text style={styles.agreementLink}>View tenancy agreement</Text>
          </Pressable>
        </Card>
      </ScrollView>
      {fileViewer.preview}
    </Screen>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  card: {
    gap: spacing.sm,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: ownerAccentColors.surfaceBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.body,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  titleTexts: {
    flex: 1,
  },
  name: {
    ...textStyles.heading3,
  },
  unit: {
    ...textStyles.caption,
    marginTop: 2,
  },
  amount: {
    ...textStyles.heading1,
    color: coreColors.brandBlue,
  },
  infoRows: {
    gap: spacing.xs,
    marginTop: spacing.xs,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  infoLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
  agreementLink: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
});
