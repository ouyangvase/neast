import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';

import { getMerchantConfig, getMerchantInfo } from '@/lib/endpoints';

/** merchantInfoProvider parity — cached merchant info, only fetched when logged in. */
export function useMerchantInfo() {
  const isLoggedIn = useIsLoggedIn();
  return useQuery({
    queryKey: ['merchant-info'],
    queryFn: getMerchantInfo,
    enabled: isLoggedIn,
  });
}

/** appConfigProvider parity — public endpoint, drives payment processing fees. */
export function useMerchantConfig() {
  return useQuery({
    queryKey: ['merchant-config'],
    queryFn: getMerchantConfig,
    staleTime: 10 * 60 * 1000,
  });
}
