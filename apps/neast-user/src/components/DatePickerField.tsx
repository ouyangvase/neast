import { useState } from 'react';
import { Modal, Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';

import { Button, coreColors, radii, spacing, textStyles } from '@neast/ui-mobile';

function pad2(value: number): string {
  return value < 10 ? `0${value}` : String(value);
}

/** `Date` → `Y-m-d` (wire format for id_valid_until). */
export function toYmd(date: Date): string {
  return `${date.getFullYear()}-${pad2(date.getMonth() + 1)}-${pad2(date.getDate())}`;
}

/** `Y-m-d` → `Date` (local midnight). */
export function fromYmd(value: string | null | undefined): Date | null {
  if (!value) {
    return null;
  }
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
  if (!match) {
    return null;
  }
  return new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]));
}

interface DatePickerFieldProps {
  label?: string;
  value: Date | null;
  onChange: (date: Date) => void;
  placeholder?: string;
}

/**
 * Wheel date picker (profile_date_picker_sheet parity): tappable field that
 * opens the spinner — Android dialog, iOS modal sheet.
 */
export function DatePickerField({
  label,
  value,
  onChange,
  placeholder = 'YYYY-MM-DD',
}: DatePickerFieldProps) {
  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState<Date>(value ?? new Date());

  const openPicker = () => {
    setDraft(value ?? new Date());
    setOpen(true);
  };

  return (
    <View>
      {label ? <Text style={styles.label}>{label}</Text> : null}
      <Pressable style={styles.field} onPress={openPicker} accessibilityRole="button">
        <Text style={[styles.value, !value && styles.placeholder]}>
          {value ? toYmd(value) : placeholder}
        </Text>
      </Pressable>

      {open && Platform.OS === 'android' ? (
        <DateTimePicker
          value={draft}
          mode="date"
          display="default"
          onChange={(event, date) => {
            setOpen(false);
            if (event.type === 'set' && date) {
              onChange(date);
            }
          }}
        />
      ) : null}

      {Platform.OS === 'ios' ? (
        <Modal visible={open} transparent animationType="fade">
          <View style={styles.overlay}>
            <View style={styles.sheet}>
              <DateTimePicker
                value={draft}
                mode="date"
                display="spinner"
                onChange={(_event, date) => {
                  if (date) {
                    setDraft(date);
                  }
                }}
              />
              <View style={styles.actions}>
                <Button
                  title="Cancel"
                  variant="ghost"
                  fullWidth={false}
                  onPress={() => setOpen(false)}
                />
                <Button
                  title="Done"
                  fullWidth={false}
                  onPress={() => {
                    onChange(draft);
                    setOpen(false);
                  }}
                />
              </View>
            </View>
          </View>
        </Modal>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  label: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    marginBottom: spacing.sm,
  },
  field: {
    borderWidth: 1,
    borderColor: coreColors.border,
    borderRadius: radii.button,
    backgroundColor: coreColors.white,
    paddingHorizontal: spacing.md,
    minHeight: 48,
    justifyContent: 'center',
  },
  value: {
    ...textStyles.body,
  },
  placeholder: {
    color: coreColors.textHint,
  },
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    justifyContent: 'flex-end',
  },
  sheet: {
    backgroundColor: coreColors.white,
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    padding: spacing.lg,
  },
  actions: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: spacing.md,
    marginTop: spacing.md,
  },
});
