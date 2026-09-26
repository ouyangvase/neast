import type { ReactNode } from 'react';
import { Pressable, StyleSheet, Text, View, type StyleProp, type ViewStyle } from 'react-native';

import { coreColors } from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { Chevron } from './Chevron';

export interface SelectFieldProps {
  label?: string;
  value?: string;
  placeholder?: string;
  onPress: () => void;
  /** Slot rendered inside the field, left of the value. */
  left?: ReactNode;
  containerStyle?: StyleProp<ViewStyle>;
}

/** Pressable field with the same chrome as `TextField`. Opens a picker. */
export function SelectField({
  label,
  value,
  placeholder,
  onPress,
  left,
  containerStyle,
}: SelectFieldProps) {
  return (
    <View style={[styles.container, containerStyle]}>
      {label ? <Text style={styles.label}>{label}</Text> : null}
      <Pressable
        accessibilityRole="button"
        accessibilityLabel={label}
        onPress={onPress}
        style={({ pressed }) => [styles.field, pressed && styles.pressed]}
      >
        {left}
        <Text numberOfLines={1} style={[styles.value, !value && styles.placeholder]}>
          {value || placeholder}
        </Text>
        <Chevron direction="down" size={8} color={coreColors.textHint} />
      </Pressable>
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
    gap: spacing.sm,
    borderWidth: 1,
    borderColor: coreColors.border,
    borderRadius: radii.button,
    backgroundColor: coreColors.white,
    paddingHorizontal: spacing.md,
    minHeight: 48,
  },
  value: {
    flex: 1,
    fontSize: textStyles.body.fontSize,
    fontWeight: textStyles.body.fontWeight,
    color: textStyles.body.color,
  },
  placeholder: {
    color: coreColors.textHint,
  },
  pressed: {
    opacity: 0.7,
  },
});
