import { Pressable, StyleSheet, Text, View } from 'react-native';

import { MONTH_NAMES_LONG } from '@neast/constant';

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { BottomSheet } from './BottomSheet';

export interface MonthValue {
  year: number;
  /** 1–12. */
  month: number;
}

/** Rolling N months ending at `from` (default: now), newest first. */
export function getRollingMonths(count = 12, from: Date = new Date()): MonthValue[] {
  const result: MonthValue[] = [];
  let year = from.getFullYear();
  let month = from.getMonth() + 1;
  for (let i = 0; i < count; i += 1) {
    result.push({ year, month });
    month -= 1;
    if (month === 0) {
      month = 12;
      year -= 1;
    }
  }
  return result;
}

export function formatMonthLabel({ year, month }: MonthValue): string {
  return `${MONTH_NAMES_LONG[month - 1]} ${year}`;
}

export interface MonthPickerProps {
  visible: boolean;
  onClose: () => void;
  onSelect: (value: MonthValue) => void;
  selected?: MonthValue;
  /** Defaults to the rolling last 12 months. */
  months?: MonthValue[];
  title?: string;
}

/** Bottom-sheet month picker (wallet top-up records, owner records). */
export function MonthPicker({
  visible,
  onClose,
  onSelect,
  selected,
  months,
  title = 'Select Month',
}: MonthPickerProps) {
  const data = months ?? getRollingMonths();
  return (
    <BottomSheet visible={visible} onClose={onClose} title={title}>
      <View style={styles.grid}>
        {data.map((value) => {
          const selected_ = value.year === selected?.year && value.month === selected?.month;
          return (
            <Pressable
              key={`${value.year}-${value.month}`}
              style={[styles.cell, selected_ && styles.cellSelected]}
              onPress={() => {
                onSelect(value);
                onClose();
              }}
              accessibilityRole="button"
            >
              <Text style={[styles.cellText, selected_ && styles.cellTextSelected]}>
                {formatMonthLabel(value)}
              </Text>
            </Pressable>
          );
        })}
      </View>
    </BottomSheet>
  );
}

const styles = StyleSheet.create({
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
  },
  cell: {
    flexBasis: '48%',
    flexGrow: 1,
    borderWidth: 1,
    borderColor: coreColors.borderLight,
    borderRadius: radii.button,
    paddingVertical: spacing.md,
    alignItems: 'center',
  },
  cellSelected: {
    borderColor: coreColors.brandBlue,
    backgroundColor: coreColors.tintBlue,
  },
  cellText: {
    ...textStyles.bodySmall,
  },
  cellTextSelected: {
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
});
