import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { VOUCHER_STATUS_TABS } from '@neast/constant';
import type { UserCouponItem, VoucherStatus } from '@neast/types';
import { coreColors, RefreshList, spacing, textStyles, userHomeColors } from '@neast/ui-mobile';

import { getMyCoupons } from '@/lib/endpoints';
import { usePaginatedList } from '@/hooks/use-paginated';
import { useSelectionStore } from '@/stores/selection';
import { CouponCard, CouponQrDialog, useCouponActions } from '@/features/coupon/components';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

/** My vouchers (my_vouchers_screen parity): active / used / expired tabs. */
export default function MyVouchersRoute() {
  const [status, setStatus] = useState<VoucherStatus>('active');
  const couponActions = useCouponActions();

  const list = usePaginatedList(
    ['my-coupons', status],
    (page, limit) => getMyCoupons(page, limit, status),
    15,
  );

  const handlePress = (item: UserCouponItem) => {
    if (item.voucher_status === 'active') {
      couponActions.showQr(item);
      return;
    }
    useSelectionStore.getState().setCoupon(item);
    router.push({ pathname: '/coupon/detail', params: { id: String(item.id) } });
  };

  return (
    <Screen edges={[]}>
      <PageHeader title="My Vouchers" />
      <View style={styles.tabs}>
        {VOUCHER_STATUS_TABS.map((tab) => (
          <Pressable
            key={tab.key}
            style={[styles.tab, status === tab.key && styles.tabActive]}
            onPress={() => setStatus(tab.key)}
            accessibilityRole="button"
          >
            <Text style={[styles.tabText, status === tab.key && styles.tabTextActive]}>
              {tab.label}
            </Text>
          </Pressable>
        ))}
      </View>
      <RefreshList<UserCouponItem>
        data={list.items}
        keyExtractor={(item) => String(item.user_coupon_id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle={`No ${status} vouchers`}
        emptyMessage="Redeem vouchers with your points from the catalog."
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => <CouponCard coupon={item} onPress={() => handlePress(item)} />}
      />
      <CouponQrDialog
        coupon={couponActions.qrCoupon}
        visible={!!couponActions.qrCoupon}
        onClose={couponActions.closeQr}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  tabs: {
    flexDirection: 'row',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.sm,
    gap: spacing.sm,
  },
  tab: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderRadius: 8,
    backgroundColor: coreColors.white,
    borderWidth: 1,
    borderColor: coreColors.border,
  },
  tabActive: {
    backgroundColor: userHomeColors.navy,
    borderColor: userHomeColors.navy,
  },
  tabText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  tabTextActive: {
    color: coreColors.white,
    fontWeight: '600',
  },
  listContent: {
    paddingVertical: spacing.sm,
  },
});
