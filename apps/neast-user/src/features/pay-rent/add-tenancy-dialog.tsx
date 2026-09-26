import type { ReactNode } from 'react';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { BlurView } from 'expo-blur';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { Chevron, EditIcon, QrCodeIcon, userHomeColors } from '@neast/ui-mobile';

/** Scan or enter details, opened from Pay Rent instead of a separate choice page. */
export function AddTenancyDialog({ visible, onClose }: { visible: boolean; onClose: () => void }) {
  const insets = useSafeAreaInsets();

  const open = (href: '/pay-rent/create/connect' | '/pay-rent/create/manual') => {
    onClose();
    router.push(href);
  };

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.root}>
        <BlurView
          intensity={28}
          tint="dark"
          blurMethod="dimezisBlurView"
          style={StyleSheet.absoluteFill}
        />
        <Pressable style={StyleSheet.absoluteFill} accessibilityLabel="Close" onPress={onClose} />
        <View style={[styles.sheet, { paddingBottom: insets.bottom + 16 }]}>
          <View style={styles.handle} />
          <View style={styles.header}>
            <View style={styles.headerCopy}>
              <Text style={styles.title}>Add tenancy</Text>
              <Text style={styles.subtitle}>How do you want to add this home?</Text>
            </View>
            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Close"
              onPress={onClose}
              style={({ pressed }) => [styles.close, pressed && styles.pressed]}
            >
              <Ionicons name="close" size={18} color={userHomeColors.textSecondary} />
            </Pressable>
          </View>
          <Choice
            title="Scan owner QR"
            subtitle="Link a property already on NEAST"
            icon={<QrCodeIcon size={22} color={userHomeColors.navy} />}
            onPress={() => open('/pay-rent/create/connect')}
          />
          <Choice
            title="Enter details"
            subtitle="For an owner who is not on NEAST yet"
            icon={<EditIcon size={22} color={userHomeColors.navy} />}
            onPress={() => open('/pay-rent/create/manual')}
          />
        </View>
      </View>
    </Modal>
  );
}

function Choice({
  title,
  subtitle,
  icon,
  onPress,
}: {
  title: string;
  subtitle: string;
  icon: ReactNode;
  onPress: () => void;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={({ pressed }) => [styles.choice, pressed && styles.pressed]}
    >
      <View style={styles.iconWell}>{icon}</View>
      <View style={styles.copy}>
        <Text style={styles.choiceTitle}>{title}</Text>
        <Text style={styles.choiceSubtitle}>{subtitle}</Text>
      </View>
      <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  sheet: {
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    paddingHorizontal: 16,
    paddingTop: 8,
    gap: 10,
    shadowColor: userHomeColors.navy,
    shadowOffset: { width: 0, height: -8 },
    shadowOpacity: 0.12,
    shadowRadius: 24,
    elevation: 16,
  },
  handle: {
    alignSelf: 'center',
    width: 40,
    height: 4,
    borderRadius: 2,
    backgroundColor: userHomeColors.border,
    marginBottom: 6,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 6,
  },
  headerCopy: {
    flex: 1,
    gap: 4,
  },
  title: {
    color: userHomeColors.navy,
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '700',
  },
  subtitle: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  close: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: userHomeColors.background,
    alignItems: 'center',
    justifyContent: 'center',
  },
  choice: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
    minHeight: 76,
    paddingHorizontal: 14,
    paddingVertical: 14,
    borderRadius: 16,
    backgroundColor: userHomeColors.background,
  },
  iconWell: {
    width: 48,
    height: 48,
    borderRadius: 14,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  copy: {
    flex: 1,
    gap: 2,
  },
  choiceTitle: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
    fontWeight: '600',
  },
  choiceSubtitle: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
  },
  pressed: {
    opacity: 0.7,
  },
});
