import { Image, Modal, StyleSheet, Text, View } from 'react-native';

import { Button, coreColors, radii, spacing, textStyles } from '@neast/ui-mobile';

interface SuccessDialogProps {
  visible: boolean;
  /** Metro asset ref (the Flutter apps' per-feature success.png). */
  image: number;
  title: string;
  message?: string;
  buttonLabel?: string;
  onClose: () => void;
}

/** Result dialog with the feature's success artwork (success_result_dialog parity). */
export function SuccessDialog({
  visible,
  image,
  title,
  message,
  buttonLabel = 'OK',
  onClose,
}: SuccessDialogProps) {
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.overlay}>
        <View style={styles.dialog}>
          <Image source={image} style={styles.image} resizeMode="contain" />
          <Text style={styles.title}>{title}</Text>
          {message ? <Text style={styles.message}>{message}</Text> : null}
          <Button title={buttonLabel} onPress={onClose} style={styles.button} />
        </View>
      </View>
    </Modal>
  );
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
    alignSelf: 'stretch',
    backgroundColor: coreColors.white,
    borderRadius: radii.card,
    padding: spacing.xl,
    alignItems: 'center',
  },
  image: {
    width: 96,
    height: 96,
    marginBottom: spacing.md,
  },
  title: {
    ...textStyles.heading2,
    textAlign: 'center',
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.sm,
  },
  button: {
    alignSelf: 'stretch',
    marginTop: spacing.lg,
  },
});
