import { api } from './api';

/**
 * Merchant deep links (`neastuser://merchant/<id>`, `https://<host>/merchant/<id>`)
 * resolve to `/merchant/<id>` via Expo Router itself — no URL parsing needed
 * (the Flutter `repairBrokenMerchantRoute` workaround was go_router-specific).
 * This predicate recognizes the resolved pathname for the guest-stash guard.
 */
export function isMerchantDetailPath(pathname: string): boolean {
  return /^\/merchant\/\d+$/.test(pathname);
}

/** Public H5 share page for a merchant (MerchantShareController). */
export function merchantShareUrl(id: number | string): string {
  return `${api.baseUrl}/merchant/${id}`;
}
