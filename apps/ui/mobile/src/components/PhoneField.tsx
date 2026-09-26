import { useState } from 'react';
import {
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

import { coreColors, userHomeColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { Chevron } from './Chevron';

export interface PhoneFieldProps {
  /** Dial code with `+`, e.g. `'+60'`. */
  dialCode: string;
  /** When set, the dial-code segment becomes tappable (open a CountryCodePicker). */
  onDialCodePress?: () => void;
  /** Local phone digits (no country code). */
  phone: string;
  onPhoneChange: (phone: string) => void;
  label?: string;
  error?: string;
  placeholder?: string;
  autoFocus?: boolean;
  style?: StyleProp<ViewStyle>;
}

/**
 * Phone number field: dial-code selector + digits input.
 * API convention: country code + digits concatenated WITHOUT `+`
 * (`+60` → `60…`) — use `getFullPhoneNumber`.
 */
export function PhoneField({
  dialCode,
  onDialCodePress,
  phone,
  onPhoneChange,
  label,
  error,
  placeholder = 'Phone number',
  autoFocus = false,
  style,
}: PhoneFieldProps) {
  const [focused, setFocused] = useState(false);
  return (
    <View style={style}>
      {label ? <Text style={styles.label}>{label}</Text> : null}
      <View style={[styles.field, focused && styles.fieldFocused, !!error && styles.fieldError]}>
        <Pressable
          style={styles.dialCode}
          onPress={onDialCodePress}
          disabled={!onDialCodePress}
          accessibilityRole="button"
        >
          <Text style={styles.dialCodeText}>{dialCode}</Text>
          {onDialCodePress ? <Chevron direction="down" color={userHomeColors.navy} size={8} /> : null}
        </Pressable>
        <View style={styles.separator} />
        <TextInput
          style={styles.input}
          value={phone}
          onChangeText={(v) => onPhoneChange(v.replace(/[^0-9]/g, ''))}
          placeholder={placeholder}
          placeholderTextColor={coreColors.textHint}
          keyboardType="phone-pad"
          autoFocus={autoFocus}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
        />
      </View>
      {error ? <Text style={styles.error}>{error}</Text> : null}
    </View>
  );
}

/** `('+60', '123456789')` → `'60123456789'` (no `+`, per API convention). */
export function getFullPhoneNumber(dialCode: string, phone: string): string {
  return `${dialCode.replace(/^\+/, '')}${phone}`;
}

const styles = StyleSheet.create({
  label: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
    marginBottom: spacing.sm,
  },
  field: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: userHomeColors.border,
    borderRadius: 16,
    backgroundColor: userHomeColors.lightBlue,
    minHeight: 56,
  },
  fieldFocused: {
    borderColor: userHomeColors.navy,
    backgroundColor: userHomeColors.surface,
  },
  fieldError: {
    borderColor: coreColors.error,
    backgroundColor: userHomeColors.surface,
  },
  dialCode: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    gap: spacing.sm,
  },
  dialCodeText: {
    ...textStyles.body,
    color: userHomeColors.navy,
    fontWeight: '700',
  },
  separator: {
    width: 1,
    height: 22,
    backgroundColor: userHomeColors.border,
  },
  input: {
    flex: 1,
    fontSize: 16,
    fontWeight: '500',
    color: userHomeColors.textPrimary,
    paddingHorizontal: spacing.md,
    paddingVertical: 0,
  },
  error: {
    ...textStyles.caption,
    color: coreColors.error,
    marginTop: spacing.xs,
  },
});
