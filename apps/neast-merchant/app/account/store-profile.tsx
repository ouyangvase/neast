import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { BrandHeader, Card, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { useMerchantInfo } from '../../src/hooks/use-merchant';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { Screen } from '../../src/components/Screen';

/** Store profile (store_profile_screen parity): read-only info from /merchant/info. */
export default function StoreProfileRoute() {
  const info = useMerchantInfo();

  return (
    <Screen>
      <BrandHeader title="Store Profile" onBack={() => router.back()} />
      {info.isLoading ? (
        <LoadingState />
      ) : info.isError || !info.data ? (
        <ErrorState onRetry={() => info.refetch()} />
      ) : (
        <ScrollView contentContainerStyle={styles.content}>
          {info.data.image ? (
            <Image source={{ uri: info.data.image }} style={styles.image} resizeMode="cover" />
          ) : null}
          <Card style={styles.card}>
            <ProfileRow label="Store name" value={info.data.name} />
            <ProfileRow label="Address" value={info.data.address} />
            <ProfileRow label="Registration no." value={info.data.registration_number} />
            <ProfileRow label="Email" value={info.data.email ?? ''} />
            <ProfileRow label="Phone" value={info.data.phone ?? ''} />
          </Card>
          <Card style={styles.card}>
            <ProfileRow label="Contact person" value={info.data.contact_name ?? ''} />
            <ProfileRow label="Contact phone" value={info.data.contact_phone ?? ''} />
            <ProfileRow label="Contact email" value={info.data.contact_email ?? ''} />
          </Card>
        </ScrollView>
      )}
    </Screen>
  );
}

function ProfileRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.row}>
      <Text style={styles.rowLabel}>{label}</Text>
      <Text style={styles.rowValue}>{value || '—'}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  content: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  image: {
    width: '100%',
    height: 180,
    borderRadius: 12,
    backgroundColor: coreColors.tintBlue,
  },
  card: {
    gap: spacing.sm,
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: spacing.md,
  },
  rowLabel: {
    ...textStyles.body,
    color: coreColors.textSecondary,
  },
  rowValue: {
    ...textStyles.body,
    fontWeight: '500',
    flex: 1,
    textAlign: 'right',
  },
});
