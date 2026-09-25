import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { BlurView } from 'expo-blur';

import { userHomeColors } from '../tokens/colors';

export interface ComingSoonDialogProps {
  visible: boolean;
  /** Supporting line under the title. */
  message: string;
  onClose: () => void;
}

/** Blurred notice other screens can open when a feature is not available yet. */
export function ComingSoonDialog({ visible, message, onClose }: ComingSoonDialogProps) {
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.fill}>
        <BlurView
          intensity={40}
          tint="light"
          blurMethod="dimezisBlurView"
          style={StyleSheet.absoluteFill}
        />
        <Pressable style={styles.fill} onPress={onClose}>
          <Pressable style={styles.dialog} onPress={() => {}}>
            <Text style={styles.title}>Coming soon</Text>
            <Text style={styles.message}>{message}</Text>
            <Pressable accessibilityRole="button" onPress={onClose} style={styles.button}>
              <Text style={styles.buttonText}>Got it</Text>
            </Pressable>
          </Pressable>
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
  button: {
    marginTop: 8,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
});
