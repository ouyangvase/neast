import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';

import { coreColors, userHomeColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { BottomSheet } from './BottomSheet';

export interface CountryCodePickerProps {
  visible: boolean;
  onClose: () => void;
  /** Dial codes with `+`, e.g. `['+60', '+65']` (from the apps' country-codes endpoint). */
  codes: string[];
  onSelect: (code: string) => void;
  selectedCode?: string;
  title?: string;
}

/** Bottom-sheet list of telephone dial codes (default login uses `+60`). */
export function CountryCodePicker({
  visible,
  onClose,
  codes,
  onSelect,
  selectedCode,
  title = 'Select country code',
}: CountryCodePickerProps) {
  return (
    <BottomSheet visible={visible} onClose={onClose} title={title}>
      <FlatList
        data={codes}
        keyExtractor={(item) => item}
        renderItem={({ item }) => {
          const selected = item === selectedCode;
          return (
            <Pressable
              style={[styles.row, selected && styles.rowSelected]}
              onPress={() => {
                onSelect(item);
                onClose();
              }}
              accessibilityRole="button"
            >
              <Text style={[styles.code, selected && styles.codeSelected]}>{item}</Text>
              {selected ? <View style={styles.dot} /> : null}
            </Pressable>
          );
        }}
      />
    </BottomSheet>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.sm,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: coreColors.divider,
  },
  rowSelected: {
    backgroundColor: userHomeColors.lightBlue,
  },
  code: {
    ...textStyles.body,
  },
  codeSelected: {
    color: userHomeColors.navy,
    fontWeight: '600',
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: userHomeColors.navy,
  },
});
