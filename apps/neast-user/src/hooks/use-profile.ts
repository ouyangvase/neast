import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';

import { getAppConfig, getUserProfile } from '../lib/endpoints';

/** userProfileProvider parity — cached profile, only fetched when logged in. */
export function useUserProfile() {
  const isLoggedIn = useIsLoggedIn();
  return useQuery({
    queryKey: ['user-profile'],
    queryFn: getUserProfile,
    enabled: isLoggedIn,
  });
}

/** appConfigProvider parity — fails closed (no alpha notice, no fee overrides). */
export function useAppConfig() {
  return useQuery({
    queryKey: ['app-config'],
    queryFn: getAppConfig,
    staleTime: 10 * 60 * 1000,
  });
}
