import { useEffect, useRef } from 'react';
import {
  Animated,
  Dimensions,
  Modal,
  Pressable,
  StyleSheet,
  Text,
  View,
  type StyleProp,
  type ViewStyle,
} from 'react-native';
import type { ReactNode } from 'react';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';

export interface BottomSheetProps {
  visible: boolean;
  onClose: () => void;
  title?: string;
  children?: ReactNode;
  /** Max height of the sheet content. Default: 70% of the screen. */
  maxHeight?: number | `${number}%`;
  /** Show the drag handle bar. Default: true. */
  showHandle?: boolean;
  /** Tap on the backdrop dismisses the sheet. Default: true. */
  dismissOnBackdrop?: boolean;
  style?: StyleProp<ViewStyle>;
}

/** Modal bottom sheet with slide-up animation and backdrop dismiss. */
export function BottomSheet({
  visible,
  onClose,
  title,
  children,
  maxHeight = '70%',
  showHandle = true,
  dismissOnBackdrop = true,
  style,
}: BottomSheetProps) {
  const translateY = useRef(new Animated.Value(Dimensions.get('window').height)).current;

  useEffect(() => {
    if (visible) {
      Animated.timing(translateY, {
        toValue: 0,
        duration: 250,
        useNativeDriver: true,
      }).start();
    } else {
      translateY.setValue(Dimensions.get('window').height);
    }
  }, [visible, translateY]);

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.overlay}>
        <Pressable
          style={styles.backdrop}
          onPress={dismissOnBackdrop ? onClose : undefined}
          accessibilityLabel="Close sheet"
        />
        <Animated.View style={[styles.sheet, { maxHeight, transform: [{ translateY }] }, style]}>
          {showHandle ? <View style={styles.handle} /> : null}
          {title ? <Text style={styles.title}>{title}</Text> : null}
          {children}
        </Animated.View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  backdrop: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
  },
  sheet: {
    backgroundColor: coreColors.white,
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.xl,
  },
  handle: {
    alignSelf: 'center',
    width: 40,
    height: 4,
    borderRadius: 2,
    backgroundColor: coreColors.border,
    marginTop: spacing.sm,
    marginBottom: spacing.md,
  },
  title: {
    ...textStyles.heading3,
    textAlign: 'center',
    marginBottom: spacing.md,
  },
});
