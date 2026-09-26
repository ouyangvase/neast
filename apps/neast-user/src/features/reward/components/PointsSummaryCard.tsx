import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatThousands, type RewardDashboard } from '@neast/types';
import { Chevron, spacing, textStyles, userHomeColors } from '@neast/ui-mobile';

import { tierIcon } from '../tier-icons';

/** Loyalty summary on the Rewards tab: balance, tier progress, and history. */
export function PointsSummaryCard({
  points,
  pointsExpiringText,
  tier,
  signedOut,
}: {
  points: number;
  pointsExpiringText: string;
  tier: RewardDashboard['tier'];
  signedOut: boolean;
}) {
  return (
    <View style={styles.card}>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel="View points history"
        onPress={() => router.push(signedOut ? '/login' : '/points/history')}
        style={({ pressed }) => [styles.points, pressed && styles.pressed]}
      >
        <View style={styles.pointsTop}>
          <Text style={styles.pointsLabel}>My Points</Text>
          <View style={styles.historyAction}>
            <Text style={styles.historyLabel}>View points history</Text>
            <Chevron direction="right" color={userHomeColors.textOnNavy} />
          </View>
        </View>
        <Text style={signedOut ? styles.pointsPrompt : styles.pointsValue}>
          {signedOut ? 'Sign in to grab your points' : formatThousands(points)}
        </Text>
        {pointsExpiringText ? <Text style={styles.pointsExpiring}>{pointsExpiringText}</Text> : null}
      </Pressable>

      <Pressable
        accessibilityRole="button"
        onPress={() => router.push(signedOut ? '/login' : '/reward/tier')}
        style={({ pressed }) => [styles.tier, pressed && styles.pressed]}
      >
        <View style={styles.tierRow}>
          <Image source={tierIcon(tier.current.id)} style={styles.tierIcon} resizeMode="contain" />
          <View style={styles.tierTexts}>
            <Text style={styles.tierName}>{tier.current.name} Tier</Text>
            <Text style={styles.tierNext}>
              {tier.next
                ? `${formatThousands(tier.pointsToNextTier)} pts to ${tier.next.name}`
                : 'Highest tier reached'}
            </Text>
          </View>
        </View>
        <View style={styles.progressTrack}>
          <View
            style={[
              styles.progressFill,
              { width: `${(tier.progressCurrent / tier.progressTarget) * 100}%` },
            ]}
          />
        </View>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.lg,
    borderRadius: 16,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
    overflow: 'hidden',
    backgroundColor: userHomeColors.surface,
  },
  points: {
    backgroundColor: userHomeColors.navy,
    padding: spacing.lg,
    gap: spacing.xs,
  },
  pointsTop: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  pointsLabel: {
    ...textStyles.caption,
    color: userHomeColors.textOnNavyMuted,
  },
  historyAction: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  historyLabel: {
    color: userHomeColors.textOnNavy,
    fontSize: 11,
    lineHeight: 14,
    fontWeight: '600',
    textAlign: 'right',
  },
  pointsValue: {
    ...textStyles.numeric,
    color: userHomeColors.surface,
  },
  pointsPrompt: {
    color: userHomeColors.surface,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  pointsExpiring: {
    ...textStyles.caption,
    color: userHomeColors.gold,
  },
  tier: {
    backgroundColor: userHomeColors.lightCream,
    padding: spacing.lg,
    gap: spacing.md,
  },
  tierRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  tierIcon: {
    width: 40,
    height: 40,
  },
  tierTexts: {
    flex: 1,
  },
  tierName: {
    ...textStyles.heading3,
    color: userHomeColors.textPrimary,
  },
  tierNext: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
  progressTrack: {
    height: 8,
    borderRadius: 999,
    backgroundColor: userHomeColors.cream,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: 999,
    backgroundColor: userHomeColors.gold,
  },
  pressed: {
    opacity: 0.7,
  },
});
