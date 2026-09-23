import { router, useLocalSearchParams } from 'expo-router';

import type { MerchantListItem } from '@neast/types';
import { BrandHeader, RefreshList, spacing } from '@neast/ui-mobile';

import {
  getMerchantList,
  getNearbyMerchantList,
  getRecommendedMerchants,
} from '../../src/lib/endpoints';
import { useDeviceLocation } from '../../src/lib/location';
import { usePaginatedList } from '../../src/hooks/use-paginated';
import { MerchantCard } from '../../src/features/merchant/components';
import { Screen } from '../../src/components/Screen';

type ListKind = 'all' | 'recommended' | 'nearby';

const HEADERS: Record<ListKind, string> = {
  all: 'All Merchants',
  recommended: 'Recommended',
  nearby: 'Nearby',
};

/** Merchant list (merchant_list_screen parity): /merchants?kind=all|recommended|nearby. */
export default function MerchantsRoute() {
  const params = useLocalSearchParams<{ kind?: string; header?: string }>();
  const kind: ListKind =
    params.kind === 'recommended' || params.kind === 'nearby' ? params.kind : 'all';
  const { coords } = useDeviceLocation();

  const list = usePaginatedList(
    ['merchants', kind, coords?.latitude ?? null, coords?.longitude ?? null],
    (page, limit) => {
      const query = {
        page,
        limit,
        latitude: coords?.latitude,
        longitude: coords?.longitude,
      };
      if (kind === 'recommended') return getRecommendedMerchants(query);
      if (kind === 'nearby') return getNearbyMerchantList(query);
      return getMerchantList(query);
    },
    15,
  );

  return (
    <Screen>
      <BrandHeader title={params.header ?? HEADERS[kind]} onBack={() => router.back()} />
      <RefreshList<MerchantListItem>
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No merchants found"
        emptyMessage="Check back soon — new partners are joining."
        contentContainerStyle={stylesListContent}
        renderItem={({ item }) => (
          <MerchantCard
            merchant={item}
            onPress={() =>
              router.push({ pathname: '/merchant/[id]', params: { id: String(item.id) } })
            }
          />
        )}
      />
    </Screen>
  );
}

const stylesListContent = { paddingVertical: spacing.lg };
