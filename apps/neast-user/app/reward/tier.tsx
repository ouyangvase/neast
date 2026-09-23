import { Image, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatThousands, type RewardTier } from '@neast/types';
import {
  Card,
  coreColors,
  GradientHeader,
  spacing,
  textStyles,
  useUiTheme,
} from '@neast/ui-mobile';

import { getRewardDashboard } from '../../src/lib/endpoints';
import { useDeviceLocation } from '../../src/lib/location';
import { tierIcon } from '../../src/features/reward/tier-icons';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { Screen } from '../../src/components/Screen';

/** Reward tiers (reward_tier_screen parity): current progress + full tier list. */
export default function RewardTierRoute() {
  const theme = useUiTheme();
  const { coords } = useDeviceLocation();
  const dashboard = useQuery({
    queryKey: ['reward-dashboard', coords?.latitude ?? null, coords?.longitude ?? null],
    queryFn: () => getRewardDashboard(coords),
  });
  const data = dashboard.data;

  return (
    <Screen edges={[]}>
      <GradientHeader
        colors={theme.gradients.header}
        title="Reward Tiers"
        onBack={() => router.back()}
      />
      {dashboard.isLoading ? (
        <LoadingState />
      ) : !data ? (
        <ErrorState onRetry={() => dashboard.refetch()} />
      ) : (
        <View style={styles.body}>
          <Card style={styles.currentCard}>
            <Image source={tierIcon(data.tier.current.id)} style={styles.currentIcon} />
            <Text style={styles.currentName}>{data.tier.current.name}</Text>
            <Text style={styles.currentPoints}>{formatThousands(data.points)} pts</Text>
            {data.tier.next ? (
              <>
                <View style={styles.progressTrack}>
                  <View
                    style={[
                      styles.progressFill,
                      {
                        backgroundColor: coreColors.brandBlue,
                        width: `${Math.min(
                          (data.tier.progressCurrent / Math.max(data.tier.progressTarget, 1)) * 100,
                          100,
                        )}%`,
                      },
                    ]}
                  />
                </View>
                <Text style={styles.nextText}>
                  {formatThousands(data.tier.pointsToNextTier)} pts to {data.tier.next.name}
                </Text>
              </>
            ) : (
              <Text style={styles.nextText}>You have reached the highest tier</Text>
            )}
          </Card>

          <View style={styles.tierList}>
            {data.tiers.map((tier) => (
              <TierRow key={tier.id} tier={tier} active={tier.id === data.tier.current.id} />
            ))}
          </View>
        </View>
      )}
    </Screen>
  );
}

function TierRow({ tier, active }: { tier: RewardTier; active: boolean }) {
  return (
    <Card style={[styles.tierRow, active && styles.tierRowActive]}>
      <Image source={tierIcon(tier.id)} style={styles.tierIcon} />
      <View style={styles.tierText}>
        <Text style={styles.tierName}>{tier.name}</Text>
        <Text style={styles.tierRange}>
          {formatThousands(tier.min_points)} – {formatThousands(tier.max_points)} pts
        </Text>
      </View>
      {active ? <Text style={styles.activeBadge}>Current</Text> : null}
    </Card>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  currentCard: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  currentIcon: {
    width: 64,
    height: 64,
  },
  currentName: {
    ...textStyles.heading2,
    marginTop: spacing.sm,
  },
  currentPoints: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.xs,
  },
  progressTrack: {
    alignSelf: 'stretch',
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.divider,
    marginTop: spacing.lg,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: 4,
  },
  nextText: {
    ...textStyles.caption,
    marginTop: spacing.sm,
  },
  tierList: {
    gap: spacing.sm,
  },
  tierRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  tierRowActive: {
    borderWidth: 1,
    borderColor: coreColors.brandBlue,
  },
  tierIcon: {
    width: 40,
    height: 40,
  },
  tierText: {
    flex: 1,
  },
  tierName: {
    ...textStyles.body,
    fontWeight: '600',
  },
  tierRange: {
    ...textStyles.caption,
    marginTop: 2,
  },
  activeBadge: {
    ...textStyles.caption,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
});
