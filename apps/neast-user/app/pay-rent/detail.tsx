import { useMemo, useState } from 'react';
import { Linking, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { formatRinggit, formatSimpleDate, RENT_STATUS } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  CountdownConfirmDialog,
  ImagePreview,
  spacing,
  StatusTag,
  textStyles,
  Toast,
  userAccentColors,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { getRentHistory, terminateRent } from '../../src/lib/endpoints';
import { isImagePath, resolveFileUrl } from '../../src/lib/files';
import { rentStatusMeta } from '../../src/lib/format';
import { isPaidHistory, type RentHistoryEntry } from '../../src/lib/types';
import { useSelectionStore } from '../../src/stores/selection';
import { ErrorState } from '../../src/components/StateViews';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

interface JourneyCell {
  key: string;
  label: string;
  state: 'paid' | 'pending' | 'due' | 'future';
}

const MONTH_INDEX: Record<string, number> = {
  january: 1,
  february: 2,
  march: 3,
  april: 4,
  may: 5,
  june: 6,
  july: 7,
  august: 8,
  september: 9,
  october: 10,
  november: 11,
  december: 12,
};

/** `October 2026` → `2026-10`; null when unparseable. */
function periodKey(rentalPeriod: string): string | null {
  const [monthName, year] = rentalPeriod.split(' ');
  const month = MONTH_INDEX[(monthName ?? '').toLowerCase()];
  if (!month || !year) return null;
  return `${year}-${String(month).padStart(2, '0')}`;
}

function addMonths(firstPayMonth: string, offset: number): string {
  const [yearRaw, monthRaw] = firstPayMonth.split('-');
  let year = Number(yearRaw);
  let month = Number(monthRaw) + offset;
  while (month > 12) {
    month -= 12;
    year += 1;
  }
  return `${year}-${String(month).padStart(2, '0')}`;
}

/** Tenancy detail (pay_rent_detail_screen parity): info, journey grid, terminate. */
export default function PayRentDetailRoute() {
  const rent = useSelectionStore((state) => state.rent);
  const queryClient = useQueryClient();
  const [terminateVisible, setTerminateVisible] = useState(false);
  const [previewVisible, setPreviewVisible] = useState(false);

  const history = useQuery({
    queryKey: ['rent-detail-history', rent?.id],
    queryFn: () => getRentHistory({ rent_id: rent!.id, page: 1, limit: 100 }),
    enabled: !!rent,
  });

  const terminateMutation = useMutation({
    mutationFn: () => terminateRent(rent!.id),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      Toast.success('Tenancy terminated');
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const journey = useMemo<JourneyCell[]>(() => {
    if (!rent) return [];
    const byPeriod = new Map<string, RentHistoryEntry>();
    for (const entry of history.data?.items ?? []) {
      const key = periodKey(entry.rental_period);
      if (key) byPeriod.set(key, entry);
    }
    const nowKey = addMonths(
      `${new Date().getFullYear()}-${String(new Date().getMonth() + 1).padStart(2, '0')}`,
      0,
    );
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return Array.from({ length: Math.max(rent.lease_months, 1) }, (_, index) => {
      const key = addMonths(rent.first_pay_month, index);
      const entry = byPeriod.get(key);
      const monthNumber = Number(key.split('-')[1]);
      let state: JourneyCell['state'] = 'future';
      if (entry && isPaidHistory(entry)) state = 'paid';
      else if (entry) state = 'pending';
      else if (key <= nowKey) state = 'due';
      return {
        key,
        label: `${monthNames[monthNumber - 1] ?? monthNumber} ${key.slice(0, 4)}`,
        state,
      };
    });
  }, [rent, history.data]);

  if (!rent) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Tenancy" />
        <ErrorState message="Tenancy unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  const status = rentStatusMeta(rent.status);
  const agreementUrl = resolveFileUrl(rent.file, rent.file_url);
  const canTerminate =
    rent.status === RENT_STATUS.approved || rent.status === RENT_STATUS.pendingBind;

  const openAgreement = () => {
    if (!agreementUrl) {
      Toast.error('No agreement uploaded');
      return;
    }
    if (isImagePath(agreementUrl)) {
      setPreviewVisible(true);
    } else {
      void Linking.openURL(agreementUrl);
    }
  };

  return (
    <Screen edges={[]}>
      <PageHeader title="Tenancy" />
      <ScrollView contentContainerStyle={styles.scroll}>
        <Card style={styles.card}>
          <View style={styles.titleRow}>
            <Text style={styles.property} numberOfLines={1}>
              {rent.property_name}
            </Text>
            <StatusTag label={status.label} status={status.tag} />
          </View>
          <Text style={styles.amount}>{formatRinggit(rent.amount)} / month</Text>
          <View style={styles.infoRows}>
            <InfoRow label="Pay day" value={rent.date_label || rent.paid_at} />
            <InfoRow label="First payment" value={rent.first_pay_month} />
            <InfoRow label="Lease" value={`${rent.lease_months} months`} />
            <InfoRow label="Expires" value={formatSimpleDate(rent.expire_date)} />
            {rent.landlord_name ? <InfoRow label="Owner" value={rent.landlord_name} /> : null}
            {rent.landlord_bank_name ? (
              <InfoRow
                label="Owner bank"
                value={`${rent.landlord_bank_name} ****${rent.landlord_bank_last4 ?? ''}`}
              />
            ) : null}
            <InfoRow label="Points per payment" value={`${rent.earn_points} pts`} />
          </View>
          <Pressable onPress={openAgreement} accessibilityRole="button">
            <Text style={styles.agreementLink}>View tenancy agreement</Text>
          </Pressable>
        </Card>

        <Card style={styles.card}>
          <Text style={styles.sectionTitle}>Property Journey</Text>
          <View style={styles.journeyGrid}>
            {journey.map((cell) => (
              <View key={cell.key} style={[styles.journeyCell, journeyCellStyle(cell.state)]}>
                <Text style={[styles.journeyText, cell.state === 'paid' && styles.journeyTextPaid]}>
                  {cell.label}
                </Text>
              </View>
            ))}
          </View>
          <View style={styles.legendRow}>
            <LegendDot color={coreColors.darkGreen} label="Paid" />
            <LegendDot color={userAccentColors.pointsDeal} label="Pending" />
            <LegendDot color={coreColors.error} label="Due" />
            <LegendDot color={coreColors.divider} label="Upcoming" />
          </View>
        </Card>

        {rent.can_pay && rent.status === RENT_STATUS.approved ? (
          <Button
            title="Pay Rent"
            onPress={() => router.push('/pay-rent/payment')}
            style={styles.actionButton}
          />
        ) : null}
        {canTerminate ? (
          <Button
            title="Terminate Tenancy"
            variant="outline"
            onPress={() => setTerminateVisible(true)}
            style={styles.actionButton}
          />
        ) : null}
      </ScrollView>

      <CountdownConfirmDialog
        visible={terminateVisible}
        title="Terminate tenancy?"
        message="This ends the tenancy and stops future rent payments. This cannot be undone."
        countdownSeconds={5}
        confirmText="Terminate"
        onConfirm={() => {
          setTerminateVisible(false);
          terminateMutation.mutate();
        }}
        onCancel={() => setTerminateVisible(false)}
      />

      {agreementUrl && isImagePath(agreementUrl) ? (
        <ImagePreview
          visible={previewVisible}
          source={{ uri: agreementUrl }}
          onClose={() => setPreviewVisible(false)}
          caption="Tenancy agreement"
        />
      ) : null}
    </Screen>
  );
}

function journeyCellStyle(state: JourneyCell['state']) {
  switch (state) {
    case 'paid':
      return { backgroundColor: coreColors.tintGreen, borderColor: coreColors.darkGreen };
    case 'pending':
      return { backgroundColor: coreColors.tintBlue, borderColor: userAccentColors.pointsDeal };
    case 'due':
      return { backgroundColor: coreColors.white, borderColor: coreColors.error };
    default:
      return { backgroundColor: coreColors.white, borderColor: coreColors.divider };
  }
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

function LegendDot({ color, label }: { color: string; label: string }) {
  return (
    <View style={styles.legendItem}>
      <View style={[styles.legendDot, { backgroundColor: color }]} />
      <Text style={styles.legendText}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
  },
  card: {
    gap: spacing.sm,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.sm,
  },
  property: {
    ...textStyles.heading3,
    flex: 1,
  },
  amount: {
    ...textStyles.heading2,
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
  },
  agreementLink: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
  sectionTitle: {
    ...textStyles.heading3,
  },
  journeyGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
    marginTop: spacing.sm,
  },
  journeyCell: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
  },
  journeyText: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  journeyTextPaid: {
    color: coreColors.darkGreen,
    fontWeight: '600',
  },
  legendRow: {
    flexDirection: 'row',
    gap: spacing.md,
    marginTop: spacing.sm,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  legendDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  legendText: {
    ...textStyles.caption,
  },
  actionButton: {
    marginTop: spacing.xs,
  },
});
