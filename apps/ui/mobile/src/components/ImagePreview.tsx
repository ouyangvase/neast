import {
  Image,
  Modal,
  Pressable,
  StyleSheet,
  Text,
  View,
  type ImageSourcePropType,
} from 'react-native';

import { coreColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

export interface ImagePreviewProps {
  visible: boolean;
  source: ImageSourcePropType;
  onClose: () => void;
  caption?: string;
}

/**
 * Full-screen image preview dialog (used for viewing uploaded tenancy
 * agreements / receipts). Pinch-to-zoom is intentionally not included —
 * add react-native-gesture-handler in the app if you need it.
 */
export function ImagePreview({ visible, source, onClose, caption }: ImagePreviewProps) {
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.overlay}>
        <Pressable style={styles.backdrop} onPress={onClose} accessibilityLabel="Close preview" />
        <Image source={source} style={styles.image} resizeMode="contain" />
        {caption ? <Text style={styles.caption}>{caption}</Text> : null}
        <Pressable
          onPress={onClose}
          accessibilityRole="button"
          accessibilityLabel="Close"
          hitSlop={12}
          style={styles.close}
        >
          <Text style={styles.closeText}>✕</Text>
        </Pressable>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.9)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  backdrop: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  image: {
    width: '100%',
    height: '80%',
  },
  caption: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    marginTop: spacing.md,
  },
  close: {
    position: 'absolute',
    top: 56,
    right: spacing.lg,
    padding: spacing.sm,
  },
  closeText: {
    fontSize: 20,
    color: coreColors.white,
  },
});
