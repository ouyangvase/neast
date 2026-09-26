import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatMonthYear, formatRinggit, formatThousands, useIsLoggedIn } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  spacing,
  StatusTag,
  textStyles,
} from '@neast/ui-mobile';

import howChargesImage from '@assets/images/settlement/how-charges.png';
import stat1Icon from '@assets/images/settlement/stat1.png';
import stat2Icon from '@assets/images/settlement/stat2.png';
import stat3Icon from '@assets/images/settlement/stat3.png';

import { Screen } from '@/components/Screen';
import { getSettlementOverview } from '@/lib/endpoints';
import { settlementDueLabel } from '@/lib/format';

/**
 * Settlement tab (settlement_screen parity): overview stats, "How charges"
 * card, Pay Now when the overview says so.
 */
export function SettlementTab() {
  const isLoggedIn = useIsLoggedIn();
  const overview = useQuery({
    queryKey: ['settlement-overview'],
    queryFn: getSettlementOverview,
    enabled: isLoggedIn,
  });

  const data = overview.data;
  const dueLabel = data ? settlementDueLabel(data.bill_month) : '';

  return (
    <Screen>
      <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scroll}>
        <Text style={styles.title}>Settlement</Text>

        <Card style={styles.billCard}>
          <View style={styles.billHeader}>
            <Text style={styles.billMonth}>
              {data ? formatMonthYear(data.bill_month) : '—'} bill
            </Text>
            {data ? (
              <StatusTag
                label={data.is_paid ? 'Paid' : 'Unpaid'}
                status={data.is_paid ? 'paid' : 'pending'}
              />
            ) : null}
          </View>
          <Text style={styles.billAmount}>{data ? formatRinggit(data.amount) : '—'}</Text>
          {data?.show_pay_now && dueLabel ? (
            <Text style={styles.billDue}>Due by {dueLabel}</Text>
          ) : null}
          <View style={styles.billStats}>
            <BillStat
              icon={stat1Icon}
              label="Points issued"
              value={data ? formatThousands(data.points) : '—'}
            />
            <BillStat
              icon={stat2Icon}
              label="Vouchers redeemed"
              value={data ? formatThousands(data.redeemed) : '—'}
            />
            <BillStat
              icon={stat3Icon}
              label="Amount"
              value={data ? formatRinggit(data.amount) : '—'}
            />
          </View>
        </Card>

        <Card style={styles.howCard}>
          <Image source={howChargesImage} style={styles.howImage} resizeMode="contain" />
          <View style={styles.howTexts}>
            <Text style={styles.howTitle}>How charges work</Text>
            <Text style={styles.howBody}>
              NEAST charges a platform commission on the points you issue each month. Settle the
              monthly bill by wallet balance or online payment.
            </Text>
          </View>
        </Card>

        {data?.show_pay_now && data.id !== null ? (
          <Button
            title="Pay Now"
            onPress={() => router.push('/settlement/payment')}
            style={styles.payButton}
          />
        ) : null}
      </ScrollView>
      </View>
    </Screen>
  );
}

function BillStat({
  icon,
  label,
  value,
}: {
  icon: number;
  label: string;
  value: string;
}) {
  return (
    <View style={styles.billStat}>
      <Image source={icon} style={styles.billStatIcon} />
      <Text style={styles.billStatValue} numberOfLines={1}>
        {value}
      </Text>
      <Text style={styles.billStatLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  title: {
    ...textStyles.heading1,
    paddingBottom: spacing.sm,
  },
  billCard: {
    gap: spacing.sm,
  },
  billHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  billMonth: {
    ...textStyles.heading3,
  },
  billAmount: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
  },
  billDue: {
    ...textStyles.bodySmall,
    color: coreColors.error,
  },
  billStats: {
    flexDirection: 'row',
    marginTop: spacing.sm,
  },
  billStat: {
    flex: 1,
    alignItems: 'center',
    gap: 2,
  },
  billStatIcon: {
    width: 28,
    height: 28,
    marginBottom: 2,
  },
  billStatValue: {
    ...textStyles.body,
    fontWeight: '700',
  },
  billStatLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    textAlign: 'center',
  },
  howCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  howImage: {
    width: 56,
    height: 56,
  },
  howTexts: {
    flex: 1,
  },
  howTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  howBody: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  payButton: {
    marginTop: spacing.sm,
  },
});
