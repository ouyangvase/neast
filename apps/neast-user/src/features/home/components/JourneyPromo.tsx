import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { useIsLoggedIn } from '@neast/types';
import { Chevron, userHomeColors } from '@neast/ui-mobile';

import tierBadge from '../../../../assets/images/home/reference-tier-badge.png';

interface JourneyPromoProps {
  /** e.g. "14 Month Streak, don't stop!"; undefined while the dashboard loads. */
  streakLabel?: string;
}

/** Journey card → tent-score; guests are routed to login. */
export function JourneyPromo({ streakLabel }: JourneyPromoProps) {
  const isLoggedIn = useIsLoggedIn();
  const loaded = isLoggedIn && streakLabel !== undefined;
  const headline = !isLoggedIn ? 'Review payment history' : loaded ? streakLabel : '…';
  const prompt = isLoggedIn ? 'Check out your tenant score' : 'Sign in to check this out';

  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel="Open payment journey"
      onPress={() => router.push(isLoggedIn ? '/account/tent-score' : '/login')}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      <Image source={tierBadge} style={styles.art} />
      <View style={styles.copy}>
        <Text style={[styles.headline, !loaded && isLoggedIn && styles.headlineMuted]}>{headline}</Text>
        <Text style={styles.prompt}>{prompt}</Text>
      </View>
      <Chevron direction="right" color={userHomeColors.textOnNavy} size={8} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    minHeight: 88,
    borderRadius: 16,
    backgroundColor: userHomeColors.navy,
    paddingVertical: 14,
    paddingLeft: 16,
    paddingRight: 14,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  art: {
    width: 40,
    height: 48,
    resizeMode: 'contain',
  },
  copy: {
    flex: 1,
    gap: 4,
  },
  headline: {
    color: userHomeColors.surface,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  headlineMuted: {
    color: userHomeColors.textOnNavyMuted,
  },
  prompt: {
    color: userHomeColors.gold,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.82,
  },
});
