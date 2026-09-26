import type { ReactNode } from 'react';
import {
  Image,
  Pressable,
  StyleSheet,
  Text,
  View,
  type ImageSourcePropType,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

import { coreColors } from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

/** Payment method ids used by the apps (`wallet_config.dart`). */
export type PaymentMethodId = 'fpx' | 'tng' | 'grab' | 'visa' | 'wallet';

export interface PaymentMethod {
  id: string;
  label: string;
  /** Secondary line under the label. */
  description?: string;
  /** Trailing fee text, e.g. `+1.6%` (from the app config processing fees). */
  feeLabel?: string;
  icon?: ImageSourcePropType;
  disabled?: boolean;
  /** Rendered inside this method's card, under the label row. */
  below?: ReactNode;
}

export interface PaymentMethodSectionProps {
  methods: PaymentMethod[];
  selectedId?: string;
  onSelect: (id: string) => void;
  title?: string;
  style?: StyleProp<ViewStyle>;
}

/** Radio-list payment method picker (wallet top-up, rent pay, settlement). */
export function PaymentMethodSection({
  methods,
  selectedId,
  onSelect,
  title = 'Payment Method',
  style,
}: PaymentMethodSectionProps) {
  return (
    <View style={style}>
      {title ? <Text style={styles.title}>{title}</Text> : null}
      <View>
        {methods.map((method) => {
          const selected = method.id === selectedId;
          return (
            <View
              key={method.id}
              style={[
                styles.row,
                selected && styles.rowSelected,
                method.disabled && styles.rowDisabled,
              ]}
            >
              <Pressable
                style={styles.header}
                onPress={() => !method.disabled && onSelect(method.id)}
                accessibilityRole="radio"
                accessibilityState={{ selected, disabled: method.disabled }}
              >
                {method.icon ? (
                  <Image source={method.icon} style={styles.icon} resizeMode="contain" />
                ) : null}
                <View style={styles.texts}>
                  <Text style={styles.label}>{method.label}</Text>
                  {method.description ? (
                    <Text style={styles.description}>{method.description}</Text>
                  ) : null}
                </View>
                {method.feeLabel ? <Text style={styles.fee}>{method.feeLabel}</Text> : null}
                <View style={[styles.radio, selected && styles.radioSelected]}>
                  {selected ? <View style={styles.radioDot} /> : null}
                </View>
              </Pressable>
              {method.below}
            </View>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  title: {
    ...textStyles.heading3,
    marginBottom: spacing.md,
  },
  row: {
    backgroundColor: coreColors.white,
    borderWidth: 1,
    borderColor: coreColors.borderLight,
    borderRadius: radii.button,
    marginBottom: spacing.sm,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
    gap: spacing.md,
  },
  rowSelected: {
    borderColor: coreColors.brandBlueLight,
    backgroundColor: coreColors.tintBlue,
  },
  rowDisabled: {
    opacity: 0.5,
  },
  icon: {
    width: 32,
    height: 32,
  },
  texts: {
    flex: 1,
  },
  label: {
    ...textStyles.body,
    fontWeight: '500',
  },
  description: {
    ...textStyles.caption,
    marginTop: 2,
  },
  fee: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  radio: {
    width: 20,
    height: 20,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: coreColors.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  radioSelected: {
    borderColor: coreColors.brandBlueLight,
  },
  radioDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    backgroundColor: coreColors.brandBlueLight,
  },
});
