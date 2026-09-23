import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import Svg, { Circle, G } from 'react-native-svg';

import { BrandHeader, Card, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { getTentScore } from '../../src/lib/endpoints';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { Screen } from '../../src/components/Screen';

const GAUGE_SIZE = 220;
const STROKE = 18;

/** Semicircle gauge: 180° arc, progress drawn via strokeDasharray. */
function ScoreGauge({ score, maxScore }: { score: number; maxScore: number }) {
  const radius = (GAUGE_SIZE - STROKE) / 2;
  const center = GAUGE_SIZE / 2;
  const arcLength = Math.PI * radius;
  const fraction = maxScore > 0 ? Math.min(score / maxScore, 1) : 0;

  return (
    <View style={styles.gaugeWrap}>
      <Svg width={GAUGE_SIZE} height={GAUGE_SIZE / 2 + STROKE}>
        <G rotation={180} origin={`${center}, ${center}`}>
          <Circle
            cx={center}
            cy={center}
            r={radius}
            stroke={coreColors.divider}
            strokeWidth={STROKE}
            strokeDasharray={`${arcLength} ${arcLength}`}
            strokeLinecap="round"
            fill="none"
          />
          <Circle
            cx={center}
            cy={center}
            r={radius}
            stroke={coreColors.brandBlue}
            strokeWidth={STROKE}
            strokeDasharray={`${arcLength * fraction} ${arcLength}`}
            strokeLinecap="round"
            fill="none"
          />
        </G>
      </Svg>
      <View style={styles.gaugeCenter}>
        <Text style={styles.gaugeScore}>{score}</Text>
        <Text style={styles.gaugeMax}>/ {maxScore}</Text>
      </View>
    </View>
  );
}

/** Tent score (tent_score_screen parity). totalPaid is server-formatted — display as-is. */
export default function TentScoreRoute() {
  const tentScore = useQuery({ queryKey: ['tent-score'], queryFn: getTentScore });
  const data = tentScore.data;

  return (
    <Screen>
      <BrandHeader title="TENT Score" onBack={() => router.back()} />
      {tentScore.isLoading ? (
        <LoadingState />
      ) : !data ? (
        <ErrorState onRetry={() => tentScore.refetch()} />
      ) : (
        <View style={styles.body}>
          <Card style={styles.gaugeCard}>
            <ScoreGauge score={data.score} maxScore={data.maxScore} />
            <Text style={styles.level}>{data.ratingLabel}</Text>
            <Text style={styles.since}>Member since {data.since}</Text>
          </Card>

          <Card style={styles.statsCard}>
            <View style={styles.statRow}>
              <Text style={styles.statLabel}>Total paid</Text>
              <Text style={styles.statValue}>{data.totalPaid}</Text>
            </View>
            <View style={styles.statRow}>
              <Text style={styles.statLabel}>Payment streak</Text>
              <Text style={styles.statValue}>
                {data.maxStreakMonths} months{data.streakLabel ? ` · ${data.streakLabel}` : ''}
              </Text>
            </View>
            <View style={styles.statRow}>
              <Text style={styles.statLabel}>On-time payments</Text>
              <Text style={styles.statValue}>{data.onTimePayments}</Text>
            </View>
            <View style={styles.statRow}>
              <Text style={styles.statLabel}>Late payments</Text>
              <Text style={styles.statValue}>{data.latePayments}</Text>
            </View>
            <View style={styles.statRow}>
              <Text style={styles.statLabel}>Verified leases</Text>
              <Text style={styles.statValue}>{data.verifiedLeases}</Text>
            </View>
          </Card>

          <Text style={styles.footer}>
            Your TENT score reflects your payment reliability as a NEAST tenant.
          </Text>
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
  gaugeWrap: {
    alignItems: 'center',
  },
  gaugeCenter: {
    position: 'absolute',
    bottom: 0,
    alignItems: 'center',
  },
  gaugeScore: {
    ...textStyles.heading1,
    fontSize: 40,
  },
  gaugeMax: {
    ...textStyles.caption,
  },
  gaugeCard: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  level: {
    ...textStyles.heading3,
    marginTop: spacing.md,
  },
  since: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
  statsCard: {
    gap: spacing.md,
  },
  statRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  statLabel: {
    ...textStyles.body,
    color: coreColors.textSecondary,
  },
  statValue: {
    ...textStyles.body,
    fontWeight: '600',
  },
  footer: {
    ...textStyles.caption,
    textAlign: 'center',
  },
});
