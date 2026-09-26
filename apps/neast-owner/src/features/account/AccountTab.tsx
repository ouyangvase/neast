import { useState } from 'react';
import {
  ImageBackground,
  Pressable,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import Constants from 'expo-constants';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery } from '@tanstack/react-query';

import {
  Chevron,
  ConfirmDialog,
  coreColors,
  spacing,
  Toast,
  userHomeColors,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { apiErrorMessage } from '@/lib/api';
import { performLogout } from '@/lib/auth';
import { deleteAccount, getLandlordInfo } from '@/lib/endpoints';

type IonName = keyof typeof Ionicons.glyphMap;

interface MenuItem {
  key: string;
  label: string;
  icon: IonName;
  onPress: () => void;
  danger?: boolean;
}

/** Account tab: identity header, then a full-width settings table. */
export function AccountTab() {
  const insets = useSafeAreaInsets();
  const info = useQuery({ queryKey: ['landlord-info'], queryFn: getLandlordInfo });
  const [deleteVisible, setDeleteVisible] = useState(false);
  const [logoutVisible, setLogoutVisible] = useState(false);

  const deleteMutation = useMutation({
    mutationFn: deleteAccount,
    onSuccess: () => {
      void performLogout();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const rows: MenuItem[] = [
    {
      key: 'bank',
      label: 'Bank Detail',
      icon: 'card-outline',
      onPress: () => router.push('/bank-detail'),
    },
    {
      key: 'about',
      label: 'About Us',
      icon: 'information-circle-outline',
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'About Us' } }),
    },
    {
      key: 'terms',
      label: 'Terms and Conditions',
      icon: 'document-text-outline',
      onPress: () =>
        router.push({ pathname: '/rich-text', params: { title: 'Terms and Conditions' } }),
    },
    {
      key: 'privacy',
      label: 'Privacy Policy',
      icon: 'shield-checkmark-outline',
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'Privacy Policy' } }),
    },
    {
      key: 'logout',
      label: 'Log Out',
      icon: 'log-out-outline',
      onPress: () => setLogoutVisible(true),
    },
    {
      key: 'delete',
      label: 'Delete Account',
      icon: 'trash-outline',
      danger: true,
      onPress: () => setDeleteVisible(true),
    },
  ];

  const profile = info.data;

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={info.isRefetching}
            onRefresh={() => {
              void info.refetch();
            }}
            colors={[userHomeColors.emptyGrey]}
            tintColor={userHomeColors.emptyGrey}
          />
        }
        contentContainerStyle={styles.scrollContent}
      >
        <ImageBackground
          source={metallicBackground}
          resizeMode="cover"
          style={[styles.backdrop, { paddingTop: insets.top + 8 }]}
        >
          <Text style={styles.title}>Account</Text>
          <View style={styles.identity}>
            {profile ? (
              <>
                <View style={styles.avatar}>
                  <Text style={styles.avatarText}>
                    {profile.first_name.charAt(0).toUpperCase()}
                  </Text>
                </View>
                <View style={styles.identityCopy}>
                  <Text style={styles.name} numberOfLines={1}>
                    {profile.name}
                  </Text>
                  <Text style={styles.contact} numberOfLines={1}>
                    +{profile.phone}
                  </Text>
                </View>
              </>
            ) : null}
          </View>
        </ImageBackground>

        <View style={styles.sheet}>
          <View style={styles.table}>
            {rows.map((item, index) => (
              <Pressable
                key={item.key}
                accessibilityRole="button"
                accessibilityLabel={item.label}
                onPress={item.onPress}
                style={({ pressed }) => [
                  styles.row,
                  index > 0 && styles.rowBorder,
                  pressed && styles.pressed,
                ]}
              >
                <Ionicons
                  name={item.icon}
                  size={20}
                  color={item.danger ? coreColors.error : userHomeColors.navy}
                />
                <Text style={[styles.rowLabel, item.danger && styles.rowLabelDanger]}>
                  {item.label}
                </Text>
                <Chevron
                  direction="right"
                  color={item.danger ? coreColors.error : userHomeColors.textSecondary}
                  size={8}
                />
              </Pressable>
            ))}
          </View>

          <Text style={styles.version}>NEAST Owner {Constants.expoConfig?.version}</Text>
        </View>
      </ScrollView>

      <ConfirmDialog
        visible={logoutVisible}
        title="Log out"
        message="Are you sure you want to log out?"
        confirmText="Log Out"
        danger
        onCancel={() => setLogoutVisible(false)}
        onConfirm={() => {
          setLogoutVisible(false);
          void performLogout();
        }}
      />
      <ConfirmDialog
        visible={deleteVisible}
        title="Delete account?"
        message="This permanently deletes your account and all associated data. This action cannot be undone."
        countdownSeconds={10}
        confirmText="Delete"
        danger
        onCancel={() => setDeleteVisible(false)}
        onConfirm={() => {
          setDeleteVisible(false);
          deleteMutation.mutate();
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scrollContent: {
    flexGrow: 1,
  },
  backdrop: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 20,
    paddingBottom: 36,
    gap: 16,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  identity: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
  },
  avatar: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: userHomeColors.cream,
    borderWidth: 2,
    borderColor: userHomeColors.gold,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    color: userHomeColors.navy,
    fontSize: 26,
    lineHeight: 32,
    fontWeight: '700',
  },
  identityCopy: {
    flex: 1,
    gap: 2,
  },
  name: {
    color: userHomeColors.surface,
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '700',
  },
  contact: {
    color: userHomeColors.textOnNavyAlt,
    fontSize: 13,
    lineHeight: 18,
  },
  sheet: {
    flex: 1,
    marginTop: -20,
    paddingTop: 18,
    paddingBottom: spacing.xl,
    gap: 16,
    backgroundColor: userHomeColors.background,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  table: {
    backgroundColor: userHomeColors.surface,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  row: {
    minHeight: 52,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingHorizontal: 20,
    backgroundColor: userHomeColors.surface,
  },
  rowBorder: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: userHomeColors.border,
  },
  rowLabel: {
    flex: 1,
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 20,
  },
  rowLabelDanger: {
    color: coreColors.error,
  },
  version: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
    textAlign: 'center',
    marginTop: spacing.sm,
  },
  pressed: {
    opacity: 0.7,
  },
});
