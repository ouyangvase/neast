import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';

import { FPX_BANKS, type FpxBank } from '@neast/constant';

import { coreColors, userHomeColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { BottomSheet } from './BottomSheet';

export type { FpxBank };

export interface FpxBankPickerProps {
  visible: boolean;
  onClose: () => void;
  onSelect: (bank: FpxBank) => void;
  /** Currently selected Fiuu channel, e.g. `fpx_mb2u`. */
  selectedChannel?: string;
  title?: string;
}

/** Bottom-sheet picker listing the 17 FPX banks. */
export function FpxBankPicker({
  visible,
  onClose,
  onSelect,
  selectedChannel,
  title = 'Select Bank',
}: FpxBankPickerProps) {
  return (
    <BottomSheet visible={visible} onClose={onClose} title={title}>
      <FlatList
        data={FPX_BANKS}
        keyExtractor={(item) => item.channel}
        renderItem={({ item }) => {
          const selected = item.channel === selectedChannel;
          return (
            <Pressable
              style={[styles.row, selected && styles.rowSelected]}
              onPress={() => {
                onSelect(item);
                onClose();
              }}
              accessibilityRole="button"
            >
              <Text style={[styles.name, selected && styles.nameSelected]}>{item.name}</Text>
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
  name: {
    ...textStyles.body,
  },
  nameSelected: {
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
