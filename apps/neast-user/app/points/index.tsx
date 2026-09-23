import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatThousands } from '@neast/types';
import {
  Card,
  Chevron,
  coreColors,
  GradientHeader,
  spacing,
  textStyles,
  useUiTheme,
} from '@neast/ui-mobile';

import { getPointsDashboard } from '../../src/lib/endpoints';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { Screen } from '../../src/components/Screen';

/** Points dashboard (points_screen parity). */
export default function PointsRoute() {
  const theme = useUiTheme();
  const dashboard = useQuery({ queryKey: ['points-dashboard'], queryFn: getPointsDashboard });
  const data = dashboard.data;

  return (
    <Screen edges={[]}>
      <GradientHeader colors={theme.gradients.header} title="Points" onBack={() => router.back()} />
      {dashboard.isLoading ? (
        <LoadingState />
      ) : !data ? (
        <ErrorState onRetry={() => dashboard.refetch()} />
      ) : (
        <View style={styles.body}>
          <Card style={styles.balanceCard}>
            <Text style={styles.balanceLabel}>Available points</Text>
            <Text style={styles.balanceValue}>{formatThousands(data.points)}</Text>
            <Text style={styles.tierText}>Current tier: {data.tier.current.name}</Text>
            {data.expiring ? (
              <Text style={styles.expiringText}>
                {formatThousands(data.expiring.points)} points expiring on{' '}
                {data.expiring.expired_date}
              </Text>
            ) : null}
          </Card>

          <Card style={styles.menuCard}>
            <Pressable
              style={styles.menuRow}
              onPress={() => router.push('/points/history')}
              accessibilityRole="button"
            >
              <Text style={styles.menuLabel}>Points history</Text>
              <Chevron />
            </Pressable>
            <Pressable
              style={[styles.menuRow, styles.menuBorder]}
              onPress={() => router.push('/reward/tier')}
              accessibilityRole="button"
            >
              <Text style={styles.menuLabel}>Reward tiers</Text>
              <Chevron />
            </Pressable>
            <Pressable
              style={[styles.menuRow, styles.menuBorder]}
              onPress={() => router.push('/coupon/my-vouchers')}
              accessibilityRole="button"
            >
              <Text style={styles.menuLabel}>My vouchers</Text>
              <View style={styles.menuRight}>
                <Text style={styles.menuValue}>{data.voucher_count}</Text>
                <Chevron />
              </View>
            </Pressable>
          </Card>

          <Card style={styles.menuCard}>
            <View style={styles.menuRow}>
              <Text style={styles.menuLabel}>Inviter reward</Text>
              <Text style={styles.menuValue}>
                {formatThousands(data.inviter_reward_points)} pts
              </Text>
            </View>
            <View style={[styles.menuRow, styles.menuBorder]}>
              <Text style={styles.menuLabel}>Invitee reward</Text>
              <Text style={styles.menuValue}>
                {formatThousands(data.invitee_reward_points)} pts
              </Text>
            </View>
          </Card>
        </View>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  balanceCard: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  balanceLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  balanceValue: {
    ...textStyles.heading1,
    fontSize: 40,
    marginTop: spacing.xs,
  },
  tierText: {
    ...textStyles.bodySmall,
    marginTop: spacing.sm,
  },
  expiringText: {
    ...textStyles.caption,
    color: coreColors.error,
    marginTop: spacing.xs,
  },
  menuCard: {
    paddingVertical: spacing.xs,
  },
  menuRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.xs,
  },
  menuBorder: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: coreColors.divider,
  },
  menuLabel: {
    ...textStyles.body,
  },
  menuRight: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  menuValue: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
});
