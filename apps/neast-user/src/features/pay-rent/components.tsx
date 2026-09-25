import { useEffect, useRef } from 'react';
import { Animated, Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit, type RentListItem } from '@neast/types';
import { Chevron, StatusTag, userHomeColors } from '@neast/ui-mobile';

import propertyPlaceholder from '../../../assets/images/home/property-hero-generated.png';

import { rentHistoryStatusMeta } from '../../lib/format';
import type { RentHistoryEntry } from '../../lib/types';
import { useSelectionStore } from '../../stores/selection';

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** `Y-m` and `Y-m-d` from the rent list, shown as `Jan 2026 – 31 Dec 2026`. */
function leaseLabel(firstPayMonth: string, expireDate: string): string {
  const [fromYear, fromMonth] = firstPayMonth.split('-');
  const [toYear, toMonth, toDay] = expireDate.split('-');
  return `${MONTHS[Number(fromMonth) - 1]} ${fromYear} – ${Number(toDay)} ${MONTHS[Number(toMonth) - 1]} ${toYear}`;
}

/** One tenancy on the Pay Rent tab. */
export function TenancyCard({ rent }: { rent: RentListItem }) {
  const setRent = useSelectionStore((state) => state.setRent);

  return (
    <Pressable
      accessibilityRole="button"
      onPress={() => {
        setRent(rent);
        router.push('/pay-rent/detail');
      }}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      <View style={styles.imageFrame}>
        <Image
          source={rent.property_image ? { uri: rent.property_image } : propertyPlaceholder}
          resizeMode="cover"
          style={styles.image}
        />
      </View>
      <View style={styles.copy}>
        <View style={styles.titleRow}>
          <Text style={styles.property} numberOfLines={1}>
            {rent.property_name}
          </Text>
          <Text style={styles.amount} numberOfLines={1}>
            {formatRinggit(rent.amount)}
          </Text>
        </View>
        <Text style={styles.meta} numberOfLines={1}>
          {rent.landlord_name}
        </Text>
        <Text style={styles.meta} numberOfLines={1}>
          {leaseLabel(rent.first_pay_month, rent.expire_date)}
        </Text>
        <View style={styles.actions}>
          {rent.can_pay ? (
            <Pressable
              accessibilityRole="button"
              onPress={() => {
                setRent(rent);
                router.push('/pay-rent/payment');
              }}
              style={({ pressed }) => [styles.payButton, pressed && styles.pressed]}
            >
              <Text style={styles.payText}>Pay</Text>
            </Pressable>
          ) : null}
          {rent.owner_linked ? (
            <Text style={styles.connectedText} numberOfLines={1}>
              Connected with owner
            </Text>
          ) : (
            <Pressable
              accessibilityRole="button"
              onPress={() => {
                setRent(rent);
                router.push('/pay-rent/invite-owner');
              }}
              style={({ pressed }) => [styles.connectButton, pressed && styles.pressed]}
            >
              <Text style={styles.connectText}>Connect with owner</Text>
            </Pressable>
          )}
        </View>
      </View>
      <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
    </Pressable>
  );
}

/** Placeholder slot while a second or third tenancy is not available yet. */
export function ComingSoonTenancyCard() {
  const pulse = useRef(new Animated.Value(0.45)).current;

  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(pulse, { toValue: 1, duration: 900, useNativeDriver: true }),
        Animated.timing(pulse, { toValue: 0.45, duration: 900, useNativeDriver: true }),
      ]),
    );
    animation.start();
    return () => animation.stop();
  }, [pulse]);

  return (
    <View style={[styles.card, styles.soonCard]}>
      <View style={styles.imageFrame}>
        <Image source={propertyPlaceholder} resizeMode="cover" style={styles.image} />
      </View>
      <View style={styles.soonSide}>
        <Animated.Text style={[styles.soonLabel, { opacity: pulse }]}>Coming soon</Animated.Text>
      </View>
    </View>
  );
}

/** Rent history row on the history list. */
export function HistoryRow({ entry, onPress }: { entry: RentHistoryEntry; onPress?: () => void }) {
  const status = rentHistoryStatusMeta(entry.status);
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={({ pressed }) => [styles.historyCard, pressed && onPress && styles.pressed]}
    >
      <View style={styles.historyTop}>
        <Text style={styles.historyPeriod} numberOfLines={1}>
          {entry.rental_period}
        </Text>
        <StatusTag label={status.label} status={status.tag} />
      </View>
      <Text style={styles.historyAmount}>{formatRinggit(entry.amount)}</Text>
      <Text style={styles.historyMeta} numberOfLines={1}>
        {entry.property_address}
        {entry.payment_no ? ` · ${entry.payment_no}` : ''}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 120,
    gap: 12,
    paddingLeft: 8,
    paddingRight: 12,
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: userHomeColors.border,
  },
  imageFrame: {
    width: 104,
    height: 104,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    overflow: 'hidden',
    backgroundColor: userHomeColors.lightBlue,
  },
  image: {
    width: '100%',
    height: '100%',
  },
  copy: {
    flex: 1,
    height: 104,
    justifyContent: 'space-between',
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  property: {
    flex: 1,
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  meta: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
  },
  amount: {
    flexShrink: 0,
    color: userHomeColors.navy,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '700',
  },
  actions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  payButton: {
    minHeight: 28,
    borderRadius: 8,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 12,
  },
  payText: {
    color: userHomeColors.surface,
    fontSize: 13,
    fontWeight: '600',
  },
  connectButton: {
    minHeight: 28,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 10,
  },
  connectText: {
    color: userHomeColors.navy,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
  },
  connectedText: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
  },
  historyCard: {
    marginHorizontal: 14,
    marginBottom: 8,
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    padding: 16,
    gap: 4,
  },
  historyTop: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
  },
  historyPeriod: {
    flex: 1,
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 21,
    fontWeight: '600',
  },
  historyAmount: {
    color: userHomeColors.textPrimary,
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '700',
  },
  historyMeta: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 17,
  },
  soonCard: {
    backgroundColor: userHomeColors.background,
  },
  soonSide: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  soonLabel: {
    color: userHomeColors.navy,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '700',
  },
  pressed: {
    opacity: 0.7,
  },
});
