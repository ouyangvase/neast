import { useState } from 'react';
import {
  StyleSheet,
  Text,
  TextInput,
  View,
  type StyleProp,
  type TextInputProps,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import type { ReactNode } from 'react';

import { coreColors } from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

export interface TextFieldProps extends Omit<TextInputProps, 'style'> {
  label?: string;
  /** Error message — switches the field to the error state when non-empty. */
  error?: string;
  /** Helper text shown when there is no error. */
  hint?: string;
  /** Slot rendered inside the field, left / right of the input. */
  left?: ReactNode;
  right?: ReactNode;
  containerStyle?: StyleProp<ViewStyle>;
  inputStyle?: StyleProp<TextStyle>;
}

export function TextField({
  label,
  error,
  hint,
  left,
  right,
  containerStyle,
  inputStyle,
  onFocus,
  onBlur,
  ...inputProps
}: TextFieldProps) {
  const [focused, setFocused] = useState(false);
  const hasError = !!error;
  return (
    <View style={[styles.container, containerStyle]}>
      {label ? <Text style={styles.label}>{label}</Text> : null}
      <View
        style={[
          styles.field,
          focused && styles.fieldFocused,
          hasError && styles.fieldError,
          inputProps.editable === false && styles.fieldDisabled,
        ]}
      >
        {left}
        <TextInput
          placeholderTextColor={coreColors.textHint}
          {...inputProps}
          onFocus={(e) => {
            setFocused(true);
            onFocus?.(e);
          }}
          onBlur={(e) => {
            setFocused(false);
            onBlur?.(e);
          }}
          style={[styles.input, inputProps.multiline ? styles.inputMultiline : null, inputStyle]}
        />
        {right}
      </View>
      {hasError ? (
        <Text style={styles.error}>{error}</Text>
      ) : hint ? (
        <Text style={styles.hint}>{hint}</Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignSelf: 'stretch',
  },
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
    paddingHorizontal: spacing.md,
    minHeight: 48,
  },
  fieldFocused: {
    borderColor: coreColors.brandBlue,
  },
  fieldError: {
    borderColor: coreColors.error,
  },
  fieldDisabled: {
    backgroundColor: coreColors.appBarBackground,
  },
  input: {
    flex: 1,
    fontSize: textStyles.body.fontSize,
    fontWeight: textStyles.body.fontWeight,
    color: textStyles.body.color,
    paddingVertical: 0,
  },
  inputMultiline: {
    lineHeight: textStyles.body.lineHeight,
    paddingVertical: spacing.md,
  },
  error: {
    ...textStyles.caption,
    color: coreColors.error,
    marginTop: spacing.xs,
  },
  hint: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
});
