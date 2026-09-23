import type { PaginatedList } from './contracts/common';

/** Default `limit` used by the backend list endpoints. */
export const DEFAULT_PAGE_SIZE = 20;

/**
 * Standard `getNextPageParam` for the backend's `{ items, total, page, limit }`
 * shape: there is a next page while `page * limit < total`.
 */
export function getNextPageParam(lastPage: PaginatedList<unknown>): number | undefined {
  const loaded = lastPage.page * lastPage.limit;
  return loaded < lastPage.total ? lastPage.page + 1 : undefined;
}

/** Minimal structural context — compatible with TanStack Query's QueryFunctionContext. */
export interface PageParamContext {
  pageParam?: number;
}

export interface PaginatedQueryConfig<T> {
  queryKey: readonly unknown[];
  /** Fetch one page; `page` is 1-based, matching the backend. */
  fetchPage: (page: number, limit: number) => Promise<PaginatedList<T>>;
  pageSize?: number;
}

/**
 * Options object shaped for `useInfiniteQuery` (structurally typed — this
 * package does not depend on @tanstack/react-query):
 *
 * ```ts
 * useInfiniteQuery(
 *   createPaginatedQuery({
 *     queryKey: ['rent-history', year],
 *     fetchPage: (page, limit) => api.get('rent/history/list', { page, limit, year }),
 *   }),
 * );
 * ```
 */
export function createPaginatedQuery<T>(config: PaginatedQueryConfig<T>): {
  queryKey: readonly unknown[];
  queryFn: (context: PageParamContext) => Promise<PaginatedList<T>>;
  initialPageParam: number;
  getNextPageParam: (lastPage: PaginatedList<T>) => number | undefined;
} {
  const pageSize = config.pageSize ?? DEFAULT_PAGE_SIZE;
  return {
    queryKey: config.queryKey,
    queryFn: (context) => config.fetchPage(context.pageParam ?? 1, pageSize),
    initialPageParam: 1,
    getNextPageParam,
  };
}

/** Flatten `data.pages` from `useInfiniteQuery` into one item array. */
export function flattenPaginatedPages<T>(pages: readonly PaginatedList<T>[]): T[] {
  const out: T[] = [];
  for (const page of pages) {
    out.push(...page.items);
  }
  return out;
}
