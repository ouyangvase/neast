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

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';

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
          {onDialCodePress ? <Text style={styles.chevron}>▾</Text> : null}
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
    ...textStyles.bodySmall,
    fontWeight: '500',
    marginBottom: spacing.sm,
  },
  field: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: coreColors.border,
    borderRadius: radii.button,
    backgroundColor: coreColors.white,
    minHeight: 48,
  },
  fieldFocused: {
    borderColor: coreColors.brandBlue,
  },
  fieldError: {
    borderColor: coreColors.error,
  },
  dialCode: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    gap: spacing.xs,
  },
  dialCodeText: {
    ...textStyles.body,
    fontWeight: '500',
  },
  chevron: {
    ...textStyles.caption,
    color: coreColors.textHint,
  },
  separator: {
    width: StyleSheet.hairlineWidth,
    height: 24,
    backgroundColor: coreColors.divider,
  },
  input: {
    flex: 1,
    ...textStyles.body,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
  },
  error: {
    ...textStyles.caption,
    color: coreColors.error,
    marginTop: spacing.xs,
  },
});
