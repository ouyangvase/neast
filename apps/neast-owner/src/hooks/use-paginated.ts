import { useMemo } from 'react';
import { useInfiniteQuery } from '@tanstack/react-query';

import {
  DEFAULT_PAGE_SIZE,
  flattenPaginatedPages,
  getNextPageParam,
  type PaginatedList,
} from '@neast/types';

/**
 * Paginated list hook (PaginatedListNotifier + AppRefresher parity):
 * pull-refresh + infinite scroll over the backend's `{items,total,page,limit}`.
 * `P` preserves response subtypes (e.g. record list carries `amount_sum`).
 */
export function usePaginatedList<T, P extends PaginatedList<T> = PaginatedList<T>>(
  queryKey: readonly unknown[],
  fetchPage: (page: number, limit: number) => Promise<P>,
  pageSize: number = DEFAULT_PAGE_SIZE,
) {
  const query = useInfiniteQuery({
    queryKey,
    queryFn: ({ pageParam }) => fetchPage(pageParam, pageSize),
    initialPageParam: 1,
    getNextPageParam: (lastPage: P) => getNextPageParam(lastPage),
  });
  const items = useMemo(() => flattenPaginatedPages(query.data?.pages ?? []), [query.data]);
  return {
    items,
    isLoading: query.isLoading,
    refreshing: query.isRefetching,
    loadingMore: query.isFetchingNextPage,
    hasMore: query.hasNextPage ?? false,
    firstPage: query.data?.pages[0],
    refresh: () => {
      void query.refetch();
    },
    loadMore: () => {
      void query.fetchNextPage();
    },
  };
}
