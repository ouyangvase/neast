import { useEffect, useState } from 'react';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';

import { coreColors, userHomeColors } from '@ui/tokens/colors';

export interface ConfirmDialogProps {
  visible: boolean;
  title: string;
  message: string;
  confirmText: string;
  onConfirm: () => void;
  onCancel: () => void;
  /** Red confirm button. Default: false. */
  danger?: boolean;
  /** Seconds the confirm button stays disabled. Omit to enable immediately. */
  countdownSeconds?: number;
}

/** Confirm card over a dim backdrop. Optional countdown holds a destructive confirm. */
export function ConfirmDialog({
  visible,
  title,
  message,
  confirmText,
  onConfirm,
  onCancel,
  danger = false,
  countdownSeconds,
}: ConfirmDialogProps) {
  const [remaining, setRemaining] = useState(0);
  const [wasVisible, setWasVisible] = useState(visible);
  if (visible !== wasVisible) {
    setWasVisible(visible);
    if (visible && countdownSeconds !== undefined) {
      setRemaining(countdownSeconds);
    }
  }

  useEffect(() => {
    if (!visible || countdownSeconds === undefined) return;
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

  const ready = remaining === 0;

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onCancel}>
      <View style={styles.fill}>
        <Pressable style={styles.backdrop} onPress={onCancel} />
        <Pressable style={styles.dialog} onPress={() => {}}>
          <Text style={styles.title}>{title}</Text>
          <Text style={styles.message}>{message}</Text>
          <View style={styles.actions}>
            <Pressable accessibilityRole="button" onPress={onCancel} style={styles.cancel}>
              <Text style={styles.cancelText}>Cancel</Text>
            </Pressable>
            <Pressable
              accessibilityRole="button"
              accessibilityState={{ disabled: !ready }}
              disabled={!ready}
              onPress={onConfirm}
              style={[styles.button, danger ? styles.danger : styles.confirm, !ready && styles.disabled]}
            >
              <Text style={styles.buttonText} numberOfLines={1}>
                {ready ? confirmText : `${confirmText} (${remaining}s)`}
              </Text>
            </Pressable>
          </View>
        </Pressable>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  fill: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  backdrop: {
    ...StyleSheet.absoluteFill,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
  },
  dialog: {
    alignSelf: 'stretch',
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    padding: 24,
    gap: 12,
  },
  title: {
    color: userHomeColors.navy,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    textAlign: 'center',
  },
  message: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
    textAlign: 'center',
  },
  actions: {
    marginTop: 8,
    flexDirection: 'row',
    gap: 12,
  },
  button: {
    flex: 1,
    minHeight: 46,
    borderRadius: 11,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 8,
  },
  confirm: {
    backgroundColor: userHomeColors.navy,
  },
  danger: {
    backgroundColor: coreColors.error,
  },
  disabled: {
    opacity: 0.5,
  },
  buttonText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  cancel: {
    flex: 1,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: coreColors.white,
    borderWidth: 1,
    borderColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
  },
  cancelText: {
    color: userHomeColors.navy,
    fontSize: 14,
    fontWeight: '600',
  },
});
