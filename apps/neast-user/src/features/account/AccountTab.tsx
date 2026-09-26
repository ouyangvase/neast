import { useState } from 'react';
import {
  Alert,
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
import { router, type Href } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery } from '@tanstack/react-query';

import { formatRinggit, useIsLoggedIn } from '@neast/types';
import {
  Chevron,
  coreColors,
  CountdownConfirmDialog,
  spacing,
  Toast,
  userHomeColors,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { apiErrorMessage } from '@/lib/api';
import { performLogout } from '@/lib/auth';
import { deleteAccount, getTentScore, getWalletBalance } from '@/lib/endpoints';
import { useUserProfile } from '@/hooks/use-profile';

type IonName = keyof typeof Ionicons.glyphMap;

interface MenuItem {
  key: string;
  label: string;
  icon: IonName;
  onPress: () => void;
  trailing?: string;
  danger?: boolean;
}

/** Account tab: identity header, My QR card, then a full-width settings table. */
export function AccountTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();
  const profile = useUserProfile();
  const [deleteVisible, setDeleteVisible] = useState(false);

  const balance = useQuery({
    queryKey: ['wallet-balance'],
    queryFn: getWalletBalance,
    enabled: isLoggedIn,
  });

  const tentScore = useQuery({
    queryKey: ['tent-score'],
    queryFn: getTentScore,
    enabled: isLoggedIn,
  });

  const deleteMutation = useMutation({
    mutationFn: deleteAccount,
    onSuccess: () => {
      void performLogout();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const open = (href: Href) => {
    router.push(isLoggedIn ? href : '/login');
  };

  const rows: MenuItem[] = [
    {
      key: 'wallet',
      label: 'Wallet',
      icon: 'wallet-outline',
      trailing: isLoggedIn
        ? balance.data
          ? formatRinggit(balance.data.balance)
          : undefined
        : 'Sign in',
      onPress: () => open('/wallet'),
    },
    {
      key: 'score',
      label: 'TENT score',
      icon: 'ribbon-outline',
      trailing: isLoggedIn
        ? tentScore.data
          ? String(tentScore.data.score)
          : undefined
        : 'Sign in',
      onPress: () => open('/account/tent-score'),
    },
    {
      key: 'personal',
      label: 'Personal Information',
      icon: 'person-outline',
      onPress: () => open('/personal-data'),
    },
    {
      key: 'privacy',
      label: 'Privacy & Security',
      icon: 'shield-checkmark-outline',
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'Privacy Policy' } }),
    },
    {
      key: 'terms',
      label: 'Terms & Conditions',
      icon: 'document-text-outline',
      onPress: () =>
        router.push({ pathname: '/rich-text', params: { title: 'Terms and Conditions' } }),
    },
  ];

  if (isLoggedIn) {
    rows.push(
      {
        key: 'logout',
        label: 'Log Out',
        icon: 'log-out-outline',
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
      {
        key: 'delete',
        label: 'Delete Account',
        icon: 'trash-outline',
        danger: true,
        onPress: () => setDeleteVisible(true),
      },
    );
  }

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          isLoggedIn ? (
            <RefreshControl
              refreshing={profile.isRefetching || balance.isRefetching || tentScore.isRefetching}
              onRefresh={() => {
                void profile.refetch();
                void balance.refetch();
                void tentScore.refetch();
              }}
              colors={[userHomeColors.emptyGrey]}
              tintColor={userHomeColors.emptyGrey}
            />
          ) : undefined
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
            <View style={styles.avatar}>
              {profile.data ? (
                <Text style={styles.avatarText}>
                  {profile.data.firstName.charAt(0).toUpperCase()}
                </Text>
              ) : null}
              {isLoggedIn ? null : (
                <Ionicons name="person" size={26} color={userHomeColors.navy} />
              )}
            </View>
            <View style={styles.identityCopy}>
              <Text style={styles.name} numberOfLines={1}>
                {profile.data ? `${profile.data.firstName} ${profile.data.lastName}` : null}
                {isLoggedIn ? null : 'Welcome to NEAST'}
              </Text>
              <Text style={styles.contact} numberOfLines={1}>
                {profile.data ? `+${profile.data.account}` : null}
                {isLoggedIn ? null : 'Sign in to manage your home.'}
              </Text>
            </View>
          </View>
          {isLoggedIn ? null : (
            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Sign in"
              onPress={() => router.push('/login')}
              style={({ pressed }) => [styles.signIn, pressed && styles.pressed]}
            >
              <Text style={styles.signInText}>Sign in</Text>
            </Pressable>
          )}
        </ImageBackground>

        <View style={styles.sheet}>
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="My QR"
            onPress={() => open('/account/my-qr')}
            style={({ pressed }) => [styles.qrCard, pressed && styles.pressed]}
          >
            <View style={styles.qrIcon}>
              <Ionicons name="qr-code-outline" size={22} color={userHomeColors.navy} />
            </View>
            <View style={styles.qrCopy}>
              <Text style={styles.qrTitle}>My QR</Text>
              <Text style={styles.qrBody}>Show this for a merchant to scan</Text>
            </View>
            <Chevron direction="right" color={userHomeColors.textOnNavy} size={8} />
          </Pressable>

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
                {item.trailing ? (
                  <Text
                    style={[styles.rowValue, !isLoggedIn && styles.rowPrompt]}
                    numberOfLines={1}
                  >
                    {item.trailing}
                  </Text>
                ) : null}
                <Chevron
                  direction="right"
                  color={item.danger ? coreColors.error : userHomeColors.textSecondary}
                  size={8}
                />
              </Pressable>
            ))}
          </View>

          <Text style={styles.version}>NEAST {Constants.expoConfig?.version}</Text>
        </View>
      </ScrollView>

      {isLoggedIn ? (
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
      ) : null}
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
  signIn: {
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
  },
  signInText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
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
  qrCard: {
    marginHorizontal: spacing.lg,
    minHeight: 76,
    borderRadius: 16,
    backgroundColor: userHomeColors.navy,
    paddingVertical: 14,
    paddingLeft: 14,
    paddingRight: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  qrIcon: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: userHomeColors.cream,
    alignItems: 'center',
    justifyContent: 'center',
  },
  qrCopy: {
    flex: 1,
    gap: 2,
  },
  qrTitle: {
    color: userHomeColors.surface,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '700',
  },
  qrBody: {
    color: userHomeColors.gold,
    fontSize: 12,
    lineHeight: 17,
    fontWeight: '600',
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
  rowValue: {
    maxWidth: '42%',
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
    textAlign: 'right',
  },
  rowPrompt: {
    color: userHomeColors.navy,
    fontWeight: '600',
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
