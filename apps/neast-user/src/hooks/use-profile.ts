import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';

import { getUserProfile } from '@/lib/endpoints';

/** userProfileProvider parity — cached profile, only fetched when logged in. */
export function useUserProfile() {
  const isLoggedIn = useIsLoggedIn();
  return useQuery({
    queryKey: ['user-profile'],
    queryFn: getUserProfile,
    enabled: isLoggedIn,
  });
}
