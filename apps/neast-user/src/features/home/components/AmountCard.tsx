import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit, useIsLoggedIn, type RentListItem } from '@neast/types';
import { userHomeColors } from '@neast/ui-mobile';

import walletArt from '../../../../assets/images/home/reference-rent-wallet.png';

import { useSelectionStore } from '../../../stores/selection';
import { useTabsStore } from '../../../stores/tabs';

/**
 * AmountCard (web parity): next-rent summary on cream with a royal-blue CTA.
 * Doubles as the guest sign-in card (replaces GuestLoginPlaceholder on home).
 */
export function AmountCard({ nextRent }: { nextRent: RentListItem | null }) {
  const isLoggedIn = useIsLoggedIn();
  const setRent = useSelectionStore((state) => state.setRent);
  const selectTab = useTabsStore((state) => state.select);

  const signedOut = !isLoggedIn;
  const ctaLabel = signedOut ? 'Sign in to pay rent' : 'Pay Rent Now';
  const onCtaPress = () => {
    if (signedOut) {
      router.push('/login');
    } else if (nextRent) {
      setRent(nextRent);
      router.push('/pay-rent/detail');
    } else {
      selectTab('payRent');
    }
  };

  return (
    <View style={styles.card}>
      <View style={styles.row}>
        <View style={styles.copy}>
          <Text style={styles.eyebrow}>Next Rent</Text>
          <Text style={styles.caption}>{nextRent?.property_name ?? 'Your tenancy'}</Text>
          <Text style={styles.title}>
            {signedOut ? 'Rent, made simple.' : nextRent ? formatRinggit(nextRent.amount) : '—'}
          </Text>
          <Text style={styles.body}>
            {signedOut
              ? 'Sign in to see your next payment.'
              : nextRent
                ? `${nextRent.due_text}${nextRent.date_label ? ` · ${nextRent.date_label}` : ''}`
                : 'Payment schedule pending'}
          </Text>
        </View>
        <Image source={walletArt} style={styles.wallet} />
      </View>
      <Pressable
        accessibilityRole="button"
        onPress={onCtaPress}
        style={({ pressed }) => [styles.cta, pressed && styles.pressed]}
      >
        <Text style={styles.ctaText}>{ctaLabel}</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: userHomeColors.cream,
    borderWidth: 1,
    borderColor: userHomeColors.cream,
    borderRadius: 16,
    padding: 16,
    gap: 18,
  },
  row: {
    flexDirection: 'row',
    gap: 12,
  },
  copy: {
    flex: 1,
    gap: 5,
  },
  eyebrow: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 21,
    fontWeight: '600',
  },
  caption: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 17,
  },
  title: {
    color: userHomeColors.textPrimary,
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '700',
  },
  body: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 19,
  },
  wallet: {
    width: 76,
    height: 86,
    resizeMode: 'contain',
  },
  cta: {
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.royalBlue,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  ctaText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
  },
});
