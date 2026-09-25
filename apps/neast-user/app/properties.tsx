import { router } from 'expo-router';

import { ComingSoon } from '@neast/ui-mobile';

/** Placeholder for the future property-browsing flow (home property promo target). */
export default function PropertiesRoute() {
  return (
    <ComingSoon
      title="Properties"
      message="Property browsing is on the way."
      onBack={() => router.back()}
    />
  );
}
