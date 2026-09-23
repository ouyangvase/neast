import { Image, Pressable, ScrollView, Share, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import * as Clipboard from 'expo-clipboard';

import { formatThousands } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import referBanner from '../assets/images/refer/refer-banner.png';

import { getReferDashboard } from '../src/lib/endpoints';
import { ErrorState, LoadingState } from '../src/components/StateViews';
import { Screen } from '../src/components/Screen';

/** Refer & earn (refer_screen parity): stats, invite code copy, share H5 link. */
export default function ReferRoute() {
  const refer = useQuery({ queryKey: ['refer-dashboard'], queryFn: getReferDashboard });
  const data = refer.data;

  const copyCode = async () => {
    if (!data) return;
    await Clipboard.setStringAsync(data.invitation_code);
    Toast.success('Invitation code copied');
  };

  const share = async () => {
    if (!data) return;
    try {
      await Share.share({
        message: `Join NEAST with my code ${data.invitation_code} and we both earn ${formatThousands(data.invitee_reward_points)} points: ${data.invite_url}`,
      });
    } catch {
      // user dismissed the share sheet
    }
  };

  return (
    <Screen>
      <BrandHeader title="Refer & Earn" onBack={() => router.back()} />
      {refer.isLoading ? (
        <LoadingState />
      ) : !data ? (
        <ErrorState onRetry={() => refer.refetch()} />
      ) : (
        <ScrollView contentContainerStyle={styles.scroll}>
          <Image source={referBanner} style={styles.banner} resizeMode="cover" />

          <View style={styles.statsRow}>
            <Card style={styles.statCard}>
              <Text style={styles.statValue}>{formatThousands(data.total_earned_points)}</Text>
              <Text style={styles.statLabel}>Points earned</Text>
            </Card>
            <Card style={styles.statCard}>
              <Text style={styles.statValue}>
                {data.invited_count}/{data.max_invite_limit}
              </Text>
              <Text style={styles.statLabel}>Friends invited</Text>
            </Card>
            <Card style={styles.statCard}>
              <Text style={styles.statValue}>{formatThousands(data.next_reward_points)}</Text>
              <Text style={styles.statLabel}>Next reward</Text>
            </Card>
          </View>

          <Card style={styles.codeCard}>
            <Text style={styles.codeLabel}>Your invitation code</Text>
            <Pressable onPress={() => void copyCode()} accessibilityRole="button">
              <Text style={styles.codeValue}>{data.invitation_code}</Text>
            </Pressable>
            <Text style={styles.codeHint}>Tap to copy</Text>
          </Card>

          <Button title="Share Invite Link" onPress={() => void share()} />
        </ScrollView>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  banner: {
    width: '100%',
    height: 140,
    borderRadius: 12,
    backgroundColor: coreColors.divider,
  },
  statsRow: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  statCard: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.md,
    gap: 2,
  },
  statValue: {
    ...textStyles.heading3,
  },
  statLabel: {
    ...textStyles.caption,
    textAlign: 'center',
  },
  codeCard: {
    alignItems: 'center',
    paddingVertical: spacing.lg,
    gap: spacing.xs,
  },
  codeLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  codeValue: {
    ...textStyles.heading1,
    letterSpacing: 2,
  },
  codeHint: {
    ...textStyles.caption,
  },
});
