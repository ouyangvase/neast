import { useMemo } from 'react';
import { useInfiniteQuery } from '@tanstack/react-query';

import {
  createPaginatedQuery,
  DEFAULT_PAGE_SIZE,
  flattenPaginatedPages,
  type PaginatedList,
} from '@neast/types';

/**
 * Paginated list hook (PaginatedListNotifier + AppRefresher parity):
 * pull-refresh + infinite scroll over the backend's `{items,total,page,limit}`.
 */
export function usePaginatedList<T>(
  queryKey: readonly unknown[],
  fetchPage: (page: number, limit: number) => Promise<PaginatedList<T>>,
  pageSize: number = DEFAULT_PAGE_SIZE,
) {
  const query = useInfiniteQuery(createPaginatedQuery<T>({ queryKey, fetchPage, pageSize }));
  const items = useMemo(() => flattenPaginatedPages(query.data?.pages ?? []), [query.data]);
  return {
    items,
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refreshing: query.isRefetching,
    loadingMore: query.isFetchingNextPage,
    hasMore: query.hasNextPage ?? false,
    refresh: () => {
      void query.refetch();
    },
    loadMore: () => {
      void query.fetchNextPage();
    },
    refetch: query.refetch,
  };
}
