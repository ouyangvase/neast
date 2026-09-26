import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import Svg, { Circle, G } from 'react-native-svg';

import { userHomeColors, PageHeader } from '@neast/ui-mobile';

import { getTentScore } from '@/lib/endpoints';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

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
            stroke={userHomeColors.textOnNavyMuted}
            strokeWidth={STROKE}
            strokeDasharray={`${arcLength} ${arcLength}`}
            strokeLinecap="round"
            fill="none"
          />
          <Circle
            cx={center}
            cy={center}
            r={radius}
            stroke={userHomeColors.gold}
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

function StatTile({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.tile}>
      <Text style={styles.tileValue}>{value}</Text>
      <Text style={styles.tileLabel}>{label}</Text>
    </View>
  );
}

/** Tenant score: current streak plus payment summary. totalPaid is server-formatted. */
export default function TentScoreRoute() {
  const tentScore = useQuery({ queryKey: ['tent-score'], queryFn: getTentScore });
  const data = tentScore.data;

  return (
    <Screen edges={[]}>
      <PageHeader title="TENT Score" />
      {tentScore.isLoading ? (
        <LoadingState />
      ) : !data ? (
        <ErrorState onRetry={() => tentScore.refetch()} />
      ) : (
        <ScrollView style={styles.scroll} contentContainerStyle={styles.body}>
          <View style={styles.hero}>
            <ScoreGauge score={data.score} maxScore={data.maxScore} />
            <Text style={styles.rating}>{data.ratingLabel}</Text>
            <View style={styles.streakStrip}>
              <Text style={styles.streakText}>{data.streakLabel}</Text>
            </View>
          </View>

          <View style={styles.grid}>
            <StatTile label="On-time payments" value={String(data.onTimePayments)} />
            <StatTile label="Late payments" value={String(data.latePayments)} />
            <StatTile label="Total paid" value={data.totalPaid} />
            <StatTile label="Verified tenancies" value={String(data.verifiedLeases)} />
          </View>
        </ScrollView>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  body: {
    padding: 14,
    gap: 14,
    paddingBottom: 28,
  },
  hero: {
    backgroundColor: userHomeColors.navy,
    borderRadius: 20,
    paddingTop: 20,
    paddingHorizontal: 16,
    paddingBottom: 16,
    alignItems: 'center',
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
    color: userHomeColors.surface,
    fontSize: 40,
    fontWeight: '700',
  },
  gaugeMax: {
    color: userHomeColors.textOnNavyMuted,
    fontSize: 13,
  },
  rating: {
    color: userHomeColors.gold,
    fontSize: 18,
    fontWeight: '700',
    marginTop: 8,
  },
  streakStrip: {
    alignSelf: 'stretch',
    marginTop: 16,
    backgroundColor: userHomeColors.cream,
    borderRadius: 12,
    paddingVertical: 12,
    paddingHorizontal: 14,
  },
  streakText: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    fontWeight: '600',
    textAlign: 'center',
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  tile: {
    width: '47%',
    flexGrow: 1,
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    padding: 16,
    gap: 6,
  },
  tileValue: {
    color: userHomeColors.royalBlue,
    fontSize: 20,
    fontWeight: '700',
  },
  tileLabel: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
  },
});
