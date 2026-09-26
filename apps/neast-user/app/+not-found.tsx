import { router } from 'expo-router';

import { NotFoundScreen } from '@neast/ui-mobile';

/** Unmatched route (not_found_screen parity). */
export default function NotFoundRoute() {
  return <NotFoundScreen app="user" onHome={() => router.replace('/')} />;
}
