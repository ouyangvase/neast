import { useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery } from '@tanstack/react-query';

import { formatRinggit, useIsLoggedIn } from '@neast/types';
import {
  Card,
  Chevron,
  coreColors,
  CountdownConfirmDialog,
  GuestLoginPlaceholder,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import MenuInfoIcon from '../../../assets/images/account/1.svg';
import MenuBellIcon from '../../../assets/images/account/2.svg';
import MenuPrivacyIcon from '../../../assets/images/account/3.svg';
import MenuTermsIcon from '../../../assets/images/account/4.svg';
import MenuLogoutIcon from '../../../assets/images/account/5.svg';
import MenuDeleteIcon from '../../../assets/images/account/del.svg';
import MenuWalletIcon from '../../../assets/images/account/wallet.svg';

import { apiErrorMessage } from '../../lib/api';
import { performLogout } from '../../lib/auth';
import { deleteAccount, getHasUnread, getWalletBalance } from '../../lib/endpoints';
import { useUserProfile } from '../../hooks/use-profile';

interface MenuItem {
  key: string;
  label: string;
  icon: React.ComponentType<{ width?: number; height?: number; color?: string }>;
  onPress: () => void;
  trailing?: string;
  danger?: boolean;
  showDot?: boolean;
}

/** Account tab (account_screen parity): profile header + menu card. */
export function AccountTab() {
  const isLoggedIn = useIsLoggedIn();
  const profile = useUserProfile();
  const [deleteVisible, setDeleteVisible] = useState(false);

  const balance = useQuery({
    queryKey: ['wallet-balance'],
    queryFn: getWalletBalance,
    enabled: isLoggedIn,
  });

  const unread = useQuery({
    queryKey: ['has-unread'],
    queryFn: getHasUnread,
    enabled: isLoggedIn,
  });

  const deleteMutation = useMutation({
    mutationFn: deleteAccount,
    onSuccess: () => {
      void performLogout();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  if (!isLoggedIn) {
    return (
      <View style={styles.guestContainer}>
        <Text style={styles.title}>Account</Text>
        <GuestLoginPlaceholder
          title="Log in to your account"
          message="Manage your profile, wallet and notifications."
          onLoginPress={() => router.push('/login')}
        />
      </View>
    );
  }

  const name = [profile.data?.firstName, profile.data?.lastName].filter(Boolean).join(' ').trim();
  const initial = (profile.data?.firstName ?? profile.data?.account ?? 'N').charAt(0).toUpperCase();

  const menu: MenuItem[] = [
    {
      key: 'personal',
      label: 'Personal Information',
      icon: MenuInfoIcon,
      onPress: () => router.push('/personal-data'),
    },
    {
      key: 'notifications',
      label: 'Notifications',
      icon: MenuBellIcon,
      onPress: () => router.push('/notification'),
      showDot: unread.data?.has_unread ?? false,
    },
    {
      key: 'wallet',
      label: 'Wallet',
      icon: MenuWalletIcon,
      onPress: () => router.push('/wallet'),
      trailing: balance.data ? formatRinggit(balance.data.balance) : undefined,
    },
    {
      key: 'privacy',
      label: 'Privacy & Security',
      icon: MenuPrivacyIcon,
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'Privacy Policy' } }),
    },
    {
      key: 'terms',
      label: 'Terms & Conditions',
      icon: MenuTermsIcon,
      onPress: () =>
        router.push({ pathname: '/rich-text', params: { title: 'Terms and Conditions' } }),
    },
    {
      key: 'delete',
      label: 'Delete Account',
      icon: MenuDeleteIcon,
      onPress: () => setDeleteVisible(true),
      danger: true,
    },
    {
      key: 'logout',
      label: 'Log Out',
      icon: MenuLogoutIcon,
      onPress: () => {
        Alert.alert('Log out', 'Are you sure you want to log out?', [
          { text: 'Cancel', style: 'cancel' },
          {
            text: 'Log Out',
            style: 'destructive',
            onPress: () => {
              void performLogout();
            },
          },
        ]);
      },
    },
  ];

  return (
    <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Text style={styles.title}>Account</Text>

        <Card style={styles.headerCard}>
          <View style={styles.headerRow}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{initial}</Text>
            </View>
            <View style={styles.headerTexts}>
              <Text style={styles.name} numberOfLines={1}>
                {name || 'NEAST User'}
              </Text>
              <Text style={styles.account} numberOfLines={1}>
                {profile.data?.account ?? ''}
              </Text>
            </View>
            <View style={styles.pointsBadge}>
              <Text style={styles.pointsBadgeText}>{profile.data?.points ?? 0} pts</Text>
            </View>
          </View>
        </Card>

        <Card padded={false} style={styles.menuCard}>
          {menu.map((item, index) => (
            <Pressable
              key={item.key}
              style={[styles.menuRow, index > 0 && styles.menuRowBorder]}
              onPress={item.onPress}
              accessibilityRole="button"
            >
              <item.icon width={22} height={22} />
              <Text style={[styles.menuLabel, item.danger && styles.menuLabelDanger]}>
                {item.label}
              </Text>
              {item.showDot ? <View style={styles.menuDot} /> : null}
              {item.trailing ? <Text style={styles.menuTrailing}>{item.trailing}</Text> : null}
              <Chevron direction="right" color={coreColors.textHint} />
            </Pressable>
          ))}
        </Card>

        <Text style={styles.version}>NEAST 1.0.13</Text>
      </ScrollView>

      <CountdownConfirmDialog
        visible={deleteVisible}
        title="Delete account?"
        message="This permanently deletes your account and all associated data. This action cannot be undone."
        countdownSeconds={10}
        confirmText="Delete"
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
    backgroundColor: coreColors.white,
  },
  guestContainer: {
    flex: 1,
    backgroundColor: coreColors.white,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  scrollContent: {
    paddingBottom: spacing.xl,
  },
  title: {
    ...textStyles.heading1,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
    paddingBottom: spacing.md,
  },
  headerCard: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  avatar: {
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: coreColors.brandBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.heading2,
    color: coreColors.white,
  },
  headerTexts: {
    flex: 1,
  },
  name: {
    ...textStyles.heading3,
  },
  account: {
    ...textStyles.caption,
    marginTop: 2,
  },
  pointsBadge: {
    backgroundColor: coreColors.tintBlue,
    borderRadius: 999,
    paddingHorizontal: spacing.sm,
    paddingVertical: 4,
  },
  pointsBadgeText: {
    ...textStyles.caption,
    color: coreColors.brandBlue,
    fontWeight: '700',
  },
  menuCard: {
    marginHorizontal: spacing.lg,
  },
  menuRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
  },
  menuRowBorder: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: coreColors.divider,
  },
  menuLabel: {
    ...textStyles.body,
    flex: 1,
  },
  menuLabelDanger: {
    color: coreColors.error,
  },
  menuDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.error,
  },
  menuTrailing: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  version: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: spacing.xl,
  },
});
