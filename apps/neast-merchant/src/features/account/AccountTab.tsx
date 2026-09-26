import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit } from '@neast/types';
import { Card, Chevron, ConfirmDialog, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import coinIcon from '@assets/images/account/coin.png';
import StoreProfileIcon from '@assets/images/account/store_profile.svg';
import WalletTopUpIcon from '@assets/images/account/wallet_top_up.svg';
import TransactionHistoryIcon from '@assets/images/account/transaction_history.svg';
import LegalIcon from '@assets/images/account/legal.svg';
import LogOutIcon from '@assets/images/account/log_out.svg';

import { Screen } from '@/components/Screen';
import { performLogout } from '@/lib/auth';
import { useMerchantInfo } from '@/hooks/use-merchant';

interface MenuItem {
  key: string;
  label: string;
  icon: React.ComponentType<{ width?: number; height?: number; color?: string }>;
  onPress: () => void;
  danger?: boolean;
}

/**
 * Account tab (account_screen parity): balance card + operations menu.
 * The Flutter "Invoice & Billing" route and "Delete Account" dialog are
 * API-less stubs and are intentionally omitted (see PARITY.md).
 */
export function AccountTab() {
  const info = useMerchantInfo();
  const [logoutVisible, setLogoutVisible] = useState(false);

  const menu: MenuItem[] = [
    {
      key: 'store-profile',
      label: 'Store Profile',
      icon: StoreProfileIcon,
      onPress: () => router.push('/account/store-profile'),
    },
    {
      key: 'wallet-top-up',
      label: 'Wallet Top Up',
      icon: WalletTopUpIcon,
      onPress: () => router.push('/wallet'),
    },
    {
      key: 'transaction-history',
      label: 'Transaction History',
      icon: TransactionHistoryIcon,
      onPress: () => router.push('/transaction-history'),
    },
    {
      key: 'legal',
      label: 'Legal',
      icon: LegalIcon,
      onPress: () => router.push({ pathname: '/rich-text', params: { title: 'Legal' } }),
    },
    {
      key: 'logout',
      label: 'Log Out',
      icon: LogOutIcon,
      danger: true,
      onPress: () => setLogoutVisible(true),
    },
  ];

  return (
    <Screen>
      <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Text style={styles.title}>Account</Text>

        <Card style={styles.balanceCard} onPress={() => router.push('/wallet')}>
          <Image source={coinIcon} style={styles.balanceIcon} />
          <View style={styles.balanceTexts}>
            <Text style={styles.balanceLabel}>Wallet balance</Text>
            <Text style={styles.balanceValue}>
              {info.data ? formatRinggit(info.data.balance) : '—'}
            </Text>
          </View>
          <Chevron direction="right" color={coreColors.textHint} />
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
              <Chevron direction="right" color={coreColors.textHint} />
            </Pressable>
          ))}
        </Card>

        <Text style={styles.version}>NEAST Merchant 1.0.6</Text>
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
  title: {
    ...textStyles.heading1,
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.md,
  },
  balanceCard: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  balanceIcon: {
    width: 40,
    height: 40,
  },
  balanceTexts: {
    flex: 1,
  },
  balanceLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  balanceValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: 2,
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
  version: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: spacing.xl,
  },
});
