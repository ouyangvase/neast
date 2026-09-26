import { useCallback, useState } from 'react';
import { Modal, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { Button, coreColors, radii, spacing, textStyles, Toast } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { getLandlordInfo } from '@/lib/endpoints';
import { queryClient } from '@/lib/query';

/**
 * Add-property bank gate (properties_screen parity): refresh the landlord
 * profile; when `bank_account` is empty show the BankDetailRequired dialog,
 * otherwise go to /add-property.
 */
export function useAddPropertyGate() {
  const [dialogVisible, setDialogVisible] = useState(false);

  const checkAndGo = useCallback(async () => {
    try {
      const info = await queryClient.fetchQuery({
        queryKey: ['landlord-info'],
        queryFn: getLandlordInfo,
        staleTime: 0,
      });
      if (info.bank_account) {
        router.push('/add-property');
      } else {
        setDialogVisible(true);
      }
    } catch (error) {
      Toast.error(apiErrorMessage(error));
    }
  }, []);

  const dialog = (
    <Modal visible={dialogVisible} transparent animationType="fade">
      <View style={styles.overlay}>
        <View style={styles.dialog}>
          <Text style={styles.title}>Bank detail required</Text>
          <Text style={styles.message}>
            Add your bank detail before creating a property, so rent payouts can reach you.
          </Text>
          <Button
            title="Add Bank Detail"
            onPress={() => {
              setDialogVisible(false);
              router.push('/bank-detail');
            }}
          />
          <Button
            title="Not now"
            variant="ghost"
            onPress={() => setDialogVisible(false)}
            style={styles.cancel}
          />
        </View>
      </View>
    </Modal>
  );

  return { checkAndGo, dialog };
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  dialog: {
    backgroundColor: coreColors.white,
    borderRadius: radii.card,
    padding: spacing.xl,
    alignSelf: 'stretch',
  },
  title: {
    ...textStyles.heading3,
    textAlign: 'center',
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.sm,
    marginBottom: spacing.lg,
  },
  cancel: {
    marginTop: spacing.sm,
  },
});
