import { useEffect, useState } from 'react';
import { Modal, StyleSheet, Text, View } from 'react-native';

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Button } from './Button';

export interface CountdownConfirmDialogProps {
  visible: boolean;
  title: string;
  message?: string;
  /** Seconds the confirm button stays disabled. Default: 10 (delete-account). */
  countdownSeconds?: number;
  confirmText?: string;
  cancelText?: string;
  onConfirm: () => void;
  onCancel: () => void;
  /** Red confirm button (destructive actions). Default: true. */
  danger?: boolean;
}

/**
 * Confirmation dialog whose confirm button only enables after a countdown —
 * used for delete-account (10s) and tenancy-terminate (5s) flows.
 */
export function CountdownConfirmDialog({
  visible,
  title,
  message,
  countdownSeconds = 10,
  confirmText = 'Confirm',
  cancelText = 'Cancel',
  onConfirm,
  onCancel,
  danger = true,
}: CountdownConfirmDialogProps) {
  const [remaining, setRemaining] = useState(countdownSeconds);

  useEffect(() => {
    if (!visible) {
      setRemaining(countdownSeconds);
      return;
    }
    setRemaining(countdownSeconds);
    const timer = setInterval(() => {
      setRemaining((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [visible, countdownSeconds]);

  const ready = remaining <= 0;

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onCancel}>
      <View style={styles.overlay}>
        <View style={styles.dialog}>
          <Text style={styles.title}>{title}</Text>
          {message ? <Text style={styles.message}>{message}</Text> : null}
          <View style={styles.actions}>
            <Button
              title={cancelText}
              variant="ghost"
              onPress={onCancel}
              fullWidth={false}
              style={styles.actionButton}
            />
            <Button
              title={ready ? confirmText : `${confirmText} (${remaining}s)`}
              variant={danger ? 'danger' : 'primary'}
              disabled={!ready}
              onPress={onConfirm}
              fullWidth={false}
              style={styles.actionButton}
            />
          </View>
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
    marginTop: spacing.md,
  },
  actions: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: spacing.md,
    marginTop: spacing.xl,
  },
  actionButton: {
    minWidth: 96,
  },
});
