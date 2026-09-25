import { useMemo } from 'react';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { RefreshList } from '@neast/ui-mobile';

import { getRentHistory } from '../../src/lib/endpoints';
import { isPaidHistory, type RentHistoryEntry } from '../../src/lib/types';
import { useSelectionStore } from '../../src/stores/selection';
import { ErrorState } from '../../src/components/StateViews';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';
import { HistoryRow } from '../../src/features/pay-rent/components';

/** Paid history for the selected tenancy. */
export default function TenancyRecentPaymentsRoute() {
  const rent = useSelectionStore((state) => state.rent);

  const history = useQuery({
    queryKey: ['rent-recent-history', rent?.id],
    queryFn: () => getRentHistory({ rent_id: rent!.id, page: 1, limit: 100 }),
    enabled: !!rent,
  });

  const items = useMemo(
    () =>
      (history.data?.items ?? [])
        .filter(isPaidHistory)
        .sort((a, b) => b.last_paid_date.localeCompare(a.last_paid_date)),
    [history.data],
  );

  if (!rent) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Recent payments" />
        <ErrorState message="Tenancy unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  return (
    <Screen edges={[]}>
      <PageHeader title="Recent payments" />
      <RefreshList<RentHistoryEntry>
        data={items}
        keyExtractor={(item) => String(item.id)}
        refreshing={history.isRefetching}
        onRefresh={() => void history.refetch()}
        emptyTitle="No payments"
        emptyMessage="Paid months for this tenancy will show up here."
        renderItem={({ item }) => (
          <HistoryRow
            entry={item}
            onPress={() => {
              useSelectionStore.getState().setHistory(item);
              router.push('/pay-rent/history/detail');
            }}
          />
        )}
      />
    </Screen>
  );
}
