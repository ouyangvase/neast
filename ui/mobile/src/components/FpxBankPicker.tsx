import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { BottomSheet } from './BottomSheet';

export interface FpxBank {
  /** Display name. */
  name: string;
  /** Fiuu `payment_channel` value (always the payer's bank). */
  channel: string;
}

/**
 * The 17 FPX banks (from the apps' `fpx_bank_config.dart`).
 */
export const FPX_BANKS: readonly FpxBank[] = [
  { name: 'Affin Bank', channel: 'fpx_abb' },
  { name: 'Alliance Bank', channel: 'fpx_abmb' },
  { name: 'AmBank', channel: 'fpx_amb' },
  { name: 'BSN', channel: 'fpx_bsn' },
  { name: 'Bank Islam', channel: 'fpx_bimb' },
  { name: 'Bank Muamalat', channel: 'fpx_bmmb' },
  { name: 'Bank Rakyat', channel: 'fpx_bkrm' },
  { name: 'CIMB Clicks', channel: 'fpx_cimbclicks' },
  { name: 'HSBC Bank', channel: 'fpx_hsbc' },
  { name: 'Hong Leong Bank', channel: 'fpx_hlb' },
  { name: 'KFH', channel: 'fpx_kfh' },
  { name: 'Maybank2U', channel: 'fpx_mb2u' },
  { name: 'OCBC Bank', channel: 'fpx_ocbc' },
  { name: 'Public Bank', channel: 'fpx_pbb' },
  { name: 'RHB Bank', channel: 'fpx_rhb' },
  { name: 'Standard Chartered', channel: 'fpx_scb' },
  { name: 'UOB Bank', channel: 'fpx_uob' },
] as const;

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
    backgroundColor: coreColors.tintBlue,
  },
  name: {
    ...textStyles.body,
  },
  nameSelected: {
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.brandBlue,
  },
});
