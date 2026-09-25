import { useState } from 'react';
import {
  Alert,
  Image,
  ImageBackground,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
  type ImageSourcePropType,
} from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery } from '@tanstack/react-query';

import {
  Card,
  Chevron,
  coreColors,
  CountdownConfirmDialog,
  sharedAssets,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { Screen } from '../../components/Screen';
import bankIcon from '../../../assets/images/coin.png';
import aboutIcon from '../../../assets/images/account/about_us.png';
import termsIcon from '../../../assets/images/account/terms_and_conditions.png';
import privacyIcon from '../../../assets/images/account/privacy_policy.png';
import deleteIcon from '../../../assets/images/account/delete_account.png';
import logoutIcon from '../../../assets/images/account/log_out.png';

import { apiErrorMessage } from '../../lib/api';
import { performLogout } from '../../lib/auth';
import { deleteAccount, getLandlordInfo } from '../../lib/endpoints';

interface MenuItem {
  key: string;
  label: string;
  icon: ImageSourcePropType;
  onPress: () => void;
  danger?: boolean;
}

/** Account tab (account_screen parity): profile header + operations menu. */
export function AccountTab() {
  const info = useQuery({ queryKey: ['landlord-info'], queryFn: getLandlordInfo });
  const [deleteVisible, setDeleteVisible] = useState(false);

  const deleteMutation = useMutation({
    mutationFn: deleteAccount,
    onSuccess: () => {
      void performLogout();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const menu: MenuItem[] = [
    {
      key: 'bank',
      label: 'Bank Detail',
      icon: bankIcon,
      onPress: () => router.push('/bank-detail'),
    },
    {
      key: 'about',
      label: 'About Us',
      icon: aboutIcon,
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'About Us' } }),
    },
    {
      key: 'terms',
      label: 'Terms and Conditions',
      icon: termsIcon,
      onPress: () =>
        router.push({ pathname: '/rich-text', params: { title: 'Terms and Conditions' } }),
    },
    {
      key: 'privacy',
      label: 'Privacy Policy',
      icon: privacyIcon,
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'Privacy Policy' } }),
    },
    {
      key: 'delete',
      label: 'Delete Account',
      icon: deleteIcon,
      onPress: () => setDeleteVisible(true),
      danger: true,
    },
    {
      key: 'logout',
      label: 'Log Out',
      icon: logoutIcon,
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
      danger: true,
    },
  ];

  const name = info.data?.name ?? '';
  const initial = (info.data?.first_name ?? '').charAt(0).toUpperCase() || 'N';

  return (
    <Screen>
      <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <ImageBackground
          source={sharedAssets.accountHeader}
          style={styles.header}
          resizeMode="cover"
        >
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{initial}</Text>
          </View>
          <Text style={styles.name} numberOfLines={1}>
            {name || 'NEAST Owner'}
          </Text>
          <Text style={styles.phone} numberOfLines={1}>
            {info.data?.phone ? `+${info.data.phone}` : ''}
          </Text>
        </ImageBackground>

        <Card padded={false} style={styles.menuCard}>
          {menu.map((item, index) => (
            <Pressable
              key={item.key}
              style={[styles.menuRow, index > 0 && styles.menuRowBorder]}
              onPress={item.onPress}
              accessibilityRole="button"
            >
              <Image source={item.icon} style={styles.menuIcon} />
              <Text style={[styles.menuLabel, item.danger && styles.menuLabelDanger]}>
                {item.label}
              </Text>
              <Chevron direction="right" color={coreColors.textHint} />
            </Pressable>
          ))}
        </Card>

        <Text style={styles.version}>NEAST Owner 1.0.6</Text>
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
    </Screen>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  scrollContent: {
    paddingBottom: spacing.xl,
  },
  header: {
    alignItems: 'center',
    paddingBottom: spacing.xl,
    paddingHorizontal: spacing.lg,
  },
  avatar: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: coreColors.white,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.heading1,
    color: coreColors.brandBlue,
  },
  name: {
    ...textStyles.heading2,
    color: coreColors.white,
    marginTop: spacing.md,
  },
  phone: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    opacity: 0.85,
    marginTop: spacing.xs,
  },
  menuCard: {
    marginHorizontal: spacing.lg,
    marginTop: spacing.lg,
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
  menuIcon: {
    width: 22,
    height: 22,
  },
  menuLabel: {
    ...textStyles.body,
    flex: 1,
  },
  menuLabelDanger: {
    color: coreColors.error,
  },
  version: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: spacing.xl,
  },
});
