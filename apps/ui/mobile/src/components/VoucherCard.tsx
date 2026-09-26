import { Image, Pressable, StyleSheet, Text, View, type ImageSourcePropType } from 'react-native';

import { userHomeColors } from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';
import { Chevron } from './Chevron';
import { StatusTag, type StatusTagStatus } from './StatusTag';

export type VoucherCardStatus = 'Active' | 'Used' | 'Expired';

export interface VoucherCardProps {
  title: string;
  merchant: string;
  status: VoucherCardStatus;
  image?: ImageSourcePropType;
  onPress?: () => void;
}

const STATUS_TONE: Record<VoucherCardStatus, StatusTagStatus> = {
  Active: 'success',
  Used: 'cancelled',
  Expired: 'overdue',
};

/** Surface row for a voucher the user already holds. */
export function VoucherCard({ title, merchant, status, image, onPress }: VoucherCardProps) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      {image ? <Image source={image} resizeMode="cover" style={styles.image} /> : null}
      <View style={styles.copy}>
        <Text style={styles.merchant} numberOfLines={1}>
          {merchant}
        </Text>
        <Text style={styles.title} numberOfLines={2}>
          {title}
        </Text>
        <StatusTag label={status} status={STATUS_TONE[status]} />
      </View>
      <Chevron direction="right" size={8} color={userHomeColors.textSecondary} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    minHeight: 86,
    backgroundColor: userHomeColors.surface,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    padding: spacing.sm,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  image: {
    width: 72,
    height: 72,
    borderRadius: 13,
    backgroundColor: userHomeColors.background,
  },
  copy: {
    flex: 1,
    gap: 5,
  },
  merchant: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    fontWeight: '800',
  },
  title: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    fontWeight: '700',
  },
  pressed: {
    opacity: 0.9,
  },
});
