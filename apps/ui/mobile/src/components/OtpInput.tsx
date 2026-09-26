import { useRef } from 'react';
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

export interface OtpInputProps {
  /** Current code (digits only). */
  value: string;
  onChange: (code: string) => void;
  /** Fired once when the last digit is entered. */
  onComplete?: (code: string) => void;
  /** Number of boxes. Default: 6 (matches the apps' OTP length). */
  length?: number;
  autoFocus?: boolean;
  /** Error state — boxes turn red. */
  hasError?: boolean;
  style?: StyleProp<ViewStyle>;
}

/** SMS OTP entry (pinput equivalent): a hidden input driving a row of boxes. */
export function OtpInput({
  value,
  onChange,
  onComplete,
  length = 6,
  autoFocus = false,
  hasError = false,
  style,
}: OtpInputProps) {
  const inputRef = useRef<TextInput>(null);

  const handleChange = (raw: string) => {
    const next = raw.replace(/[^0-9]/g, '').slice(0, length);
    onChange(next);
    if (next.length === length) onComplete?.(next);
  };

  const boxes = Array.from({ length }, (_, i) => value[i] ?? '');
  const activeIndex = Math.min(value.length, length - 1);

  return (
    <Pressable
      style={[styles.row, style]}
      onPress={() => inputRef.current?.focus()}
      accessibilityRole="none"
    >
      <TextInput
        ref={inputRef}
        style={styles.hiddenInput}
        value={value}
        onChangeText={handleChange}
        keyboardType="number-pad"
        textContentType="oneTimeCode"
        autoComplete="sms-otp"
        maxLength={length}
        autoFocus={autoFocus}
        caretHidden
      />
      {boxes.map((digit, i) => (
        <View
          key={i}
          style={[
            styles.box,
            digit !== '' && styles.boxFilled,
            i === activeIndex && styles.boxActive,
            hasError && styles.boxError,
          ]}
        >
          <Text style={styles.digit}>{digit}</Text>
        </View>
      ))}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    gap: 8,
    alignSelf: 'stretch',
  },
  hiddenInput: {
    position: 'absolute',
    width: 1,
    height: 1,
    opacity: 0,
  },
  box: {
    flex: 1,
    height: 58,
    borderRadius: 16,
    borderWidth: 1.5,
    borderColor: userHomeColors.border,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  boxFilled: {
    backgroundColor: userHomeColors.surface,
  },
  boxActive: {
    borderColor: userHomeColors.navy,
    backgroundColor: userHomeColors.surface,
  },
  boxError: {
    borderColor: coreColors.error,
  },
  digit: {
    fontSize: 22,
    fontWeight: '700',
    color: userHomeColors.textPrimary,
  },
});
