import type { ReactNode } from 'react';
import {
  ActivityIndicator,
  Pressable,
  StyleSheet,
  Text,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';

import { coreColors, userHomeColors } from '@ui/tokens/colors';
import { radii } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

export type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'danger' | 'ghost';
export type ButtonSize = 'small' | 'medium' | 'large';

export interface ButtonProps {
  title: string;
  onPress?: () => void;
  /** `primary` = navy action. Default: `primary`. */
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  disabled?: boolean;
  /** Stretch to fill the parent width. Default: true. */
  fullWidth?: boolean;
  /** Shown before the label. Hidden while loading. */
  icon?: ReactNode;
  style?: StyleProp<ViewStyle>;
  textStyle?: StyleProp<TextStyle>;
}

export function Button({
  title,
  onPress,
  variant = 'primary',
  size = 'medium',
  loading = false,
  disabled = false,
  fullWidth = true,
  icon,
  style,
  textStyle,
}: ButtonProps) {
  const isDisabled = disabled || loading;
  return (
    <Pressable
      accessibilityRole="button"
      disabled={isDisabled}
      onPress={onPress}
      style={({ pressed }) => [
        styles.base,
        styles[`size_${size}`],
        styles[`variant_${variant}`],
        fullWidth && styles.fullWidth,
        pressed && !isDisabled && styles.pressed,
        isDisabled && styles.disabled,
        style,
      ]}
    >
      {loading ? (
        <ActivityIndicator
          color={
            variant === 'outline' || variant === 'ghost' ? userHomeColors.navy : coreColors.white
          }
        />
      ) : (
        <>
          {icon}
          <Text
            style={[styles.label, styles[`label_${variant}`], styles[`labelSize_${size}`], textStyle]}
          >
            {title}
          </Text>
        </>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  base: {
    borderRadius: radii.button,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
    gap: 8,
  },
  fullWidth: {
    alignSelf: 'stretch',
  },
  size_small: {
    height: 36,
    paddingHorizontal: 16,
  },
  size_medium: {
    height: 48,
    paddingHorizontal: 20,
  },
  size_large: {
    height: 56,
    paddingHorizontal: 24,
  },
  variant_primary: {
    backgroundColor: userHomeColors.navy,
  },
  variant_secondary: {
    backgroundColor: userHomeColors.navy,
  },
  variant_outline: {
    backgroundColor: coreColors.white,
    borderWidth: 1,
    borderColor: userHomeColors.navy,
  },
  variant_danger: {
    backgroundColor: coreColors.error,
  },
  variant_ghost: {
    backgroundColor: 'transparent',
  },
  pressed: {
    opacity: 0.85,
  },
  disabled: {
    opacity: 0.5,
  },
  label: {
    ...textStyles.button,
  },
  labelSize_small: {
    fontSize: 14,
    lineHeight: 20,
  },
  labelSize_medium: {},
  labelSize_large: {
    fontSize: 18,
    lineHeight: 26,
  },
  label_primary: {
    color: coreColors.white,
  },
  label_secondary: {
    color: coreColors.white,
  },
  label_outline: {
    color: userHomeColors.navy,
  },
  label_danger: {
    color: coreColors.white,
  },
  label_ghost: {
    color: userHomeColors.navy,
  },
});
