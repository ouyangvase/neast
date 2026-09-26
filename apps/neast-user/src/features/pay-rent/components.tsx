import { useEffect, useRef } from 'react';
import { Animated, Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { MONTH_NAMES_SHORT } from '@neast/constant';
import { formatRinggit, type RentListItem } from '@neast/types';
import { Chevron, StatusTag, SuccessMark, textStyles, userHomeColors } from '@neast/ui-mobile';

import propertyPlaceholder from '@assets/images/home/property-hero-generated.png';

import { rentHistoryStatusMeta, rentStatusMeta, type StatusMeta } from '@/lib/format';
import type { RentHistoryEntry } from '@/lib/types';
import { useSelectionStore } from '@/stores/selection';

/** `Y-m` and `Y-m-d` from the rent list, shown as `Jan 2026 – 31 Dec 2026`. */
function leaseLabel(firstPayMonth: string, expireDate: string): string {
  const [fromYear, fromMonth] = firstPayMonth.split('-');
  const [toYear, toMonth, toDay] = expireDate.split('-');
  return `${MONTH_NAMES_SHORT[Number(fromMonth) - 1]} ${fromYear} – ${Number(toDay)} ${MONTH_NAMES_SHORT[Number(toMonth) - 1]} ${toYear}`;
}

/** One tenancy on the Pay Rent tab. `summary` is the static card on tenancy details. */
export function TenancyCard({ rent, summary = false }: { rent: RentListItem; summary?: boolean }) {
  const setRent = useSelectionStore((state) => state.setRent);
  const status = rentStatusMeta(rent.status);

  const body = (
    <>
      <View style={[styles.photo, summary && styles.summaryPhoto]}>
        <View style={[styles.imageFrame, summary && styles.summaryImageFrame]}>
          <Image
            source={rent.property_image ? { uri: rent.property_image } : propertyPlaceholder}
            resizeMode="cover"
            style={styles.image}
          />
        </View>
        {summary ? null : (
          <StatusTag
            label={status.label}
            status={status.tag}
            style={styles.statusTag}
            labelStyle={styles.statusLabel}
          />
        )}
      </View>
      <View style={[styles.copy, summary && styles.summaryCopy]}>
        <View style={styles.titleRow}>
          <Text style={styles.property} numberOfLines={1}>
            {rent.property_name}
          </Text>
          {summary ? null : (
            <Text style={styles.amount} numberOfLines={1}>
              {formatRinggit(rent.amount)}
            </Text>
          )}
        </View>
        <Text style={styles.meta} numberOfLines={1}>
          {rent.landlord_name}
        </Text>
        <Text style={styles.meta} numberOfLines={1}>
          {leaseLabel(rent.first_pay_month, rent.expire_date)}
        </Text>
        {summary ? null : (
          <View style={styles.actions}>
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
        )}
      </View>
      {summary ? (
        <StatusTag
          label={status.label}
          status={status.tag}
          style={styles.summaryStatus}
          labelStyle={styles.statusLabel}
        />
      ) : (
        <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
      )}
    </>
  );

  if (summary) {
    return <View style={[styles.card, styles.summaryCard]}>{body}</View>;
  }

  return (
    <Pressable
      accessibilityRole="button"
      onPress={() => {
        setRent(rent);
        router.push('/pay-rent/detail');
      }}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      {body}
    </Pressable>
  );
}

/** Empty Pay Rent slot. The parent decides what the tap does. */
export function AddTenancyCard({
  label = 'Add new tenancy now',
  onPress,
}: {
  label?: string;
  onPress: () => void;
}) {
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
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={({ pressed }) => [styles.card, styles.soonCard, pressed && styles.pressed]}
    >
      <View style={styles.placeholderFrame}>
        <Image source={propertyPlaceholder} resizeMode="cover" style={styles.image} />
      </View>
      <View style={styles.soonSide}>
        <Animated.Text style={[styles.soonLabel, { opacity: pulse }]}>{label}</Animated.Text>
      </View>
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
      <View style={styles.placeholderFrame}>
        <Image source={propertyPlaceholder} resizeMode="cover" style={styles.image} />
      </View>
      <View style={styles.soonSide}>
        <Animated.Text style={[styles.soonLabel, { opacity: pulse }]}>Coming soon</Animated.Text>
      </View>
    </View>
  );
}

/** Completed-payment header: green check, amount, and period. Status pill is optional. */
export function PaymentSuccessHero({
  amount,
  period,
  status,
}: {
  amount: string;
  period: string;
  status?: StatusMeta;
}) {
  return (
    <View style={styles.hero}>
      <SuccessMark />
      <Text style={styles.heroTitle}>Payment successful</Text>
      <Text style={styles.heroAmount}>{amount}</Text>
      <Text style={styles.heroPeriod}>{period}</Text>
      {status ? <StatusTag label={status.label} status={status.tag} /> : null}
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
      <View style={styles.historyBody}>
        <Text style={styles.historyPeriod} numberOfLines={1}>
          {entry.rental_period}
        </Text>
        <Text style={styles.historyAmount}>{formatRinggit(entry.amount)}</Text>
        <Text style={styles.historyMeta} numberOfLines={1}>
          {entry.property_address} · {entry.payment_no}
        </Text>
      </View>
      <StatusTag label={status.label} status={status.tag} style={styles.historyStatus} />
      <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
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
  photo: {
    width: 104,
    height: 104,
  },
  summaryPhoto: {
    width: 72,
    height: 72,
  },
  imageFrame: {
    width: '100%',
    height: '100%',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    overflow: 'hidden',
    backgroundColor: userHomeColors.lightBlue,
  },
  placeholderFrame: {
    width: 104,
    height: 104,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    overflow: 'hidden',
    backgroundColor: userHomeColors.lightBlue,
  },
  summaryCard: {
    height: 88,
    gap: 10,
    paddingLeft: 8,
    paddingRight: 12,
    borderRadius: 12,
  },
  summaryImageFrame: {
    borderRadius: 10,
  },
  summaryCopy: {
    height: 72,
    justifyContent: 'center',
    gap: 2,
  },
  image: {
    width: '100%',
    height: '100%',
  },
  statusTag: {
    position: 'absolute',
    top: 4,
    left: 4,
    paddingHorizontal: 5,
    paddingVertical: 1,
  },
  summaryStatus: {
    alignSelf: 'center',
    paddingHorizontal: 5,
    paddingVertical: 1,
  },
  statusLabel: {
    fontSize: 8,
    lineHeight: 10,
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
  hero: {
    alignItems: 'center',
    gap: 8,
    paddingVertical: 8,
  },
  heroTitle: {
    ...textStyles.heading3,
    color: userHomeColors.textPrimary,
  },
  heroAmount: {
    ...textStyles.displayLarge,
    color: userHomeColors.textPrimary,
  },
  heroPeriod: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
  },
  historyCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 14,
    marginBottom: 8,
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    padding: 12,
    gap: 8,
  },
  historyBody: {
    flex: 1,
    gap: 2,
  },
  historyStatus: {
    alignSelf: 'center',
  },
  historyPeriod: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 21,
    fontWeight: '600',
  },
  historyAmount: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
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
    textAlign: 'center',
  },
  pressed: {
    opacity: 0.7,
  },
});
