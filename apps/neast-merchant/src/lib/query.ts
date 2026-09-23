import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // The documented client flow is single-attempt (refresh-on-400 lives in
      // the API client); TanStack's default 3 retries would be off-path.
      retry: false,
      staleTime: 30_000,
      refetchOnWindowFocus: false,
    },
  },
});
