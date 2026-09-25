import { useState } from 'react';
import { StyleSheet, Text } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { Button, coreColors, textStyles, Toast } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../../src/lib/api';
import { openScanner } from '../../../src/lib/callbacks';
import { createRent, getRentPropertyBySn } from '../../../src/lib/endpoints';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';
import { TenancyForm } from '../../../src/features/pay-rent/tenancy-form';

interface ConnectedProperty {
  propertyId: number;
  propertyName: string;
  ownerName: string;
}

/** Connect path: scan the owner's QR, then the shared tenancy fields. */
export default function ConnectTenancyRoute() {
  const queryClient = useQueryClient();
  const params = useLocalSearchParams<{
    propertyId?: string;
    propertyName?: string;
    ownerName?: string;
  }>();
  const [connected, setConnected] = useState<ConnectedProperty | null>(
    params.propertyName
      ? {
          propertyId: Number(params.propertyId),
          propertyName: params.propertyName,
          ownerName: params.ownerName ?? '',
        }
      : null,
  );

  const scanConnect = () => {
    openScanner((value) => {
      getRentPropertyBySn(value)
        .then((property) => {
          setConnected({
            propertyId: property.id,
            propertyName: property.name,
            ownerName: property.landlord_name,
          });
          Toast.success(`Connected to ${property.name}`);
        })
        .catch((error: unknown) => Toast.error(apiErrorMessage(error)));
    });
  };

  const createMutation = useMutation({
    mutationFn: createRent,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      Toast.success('Tenancy submitted for review');
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  return (
    <Screen edges={[]}>
      <PageHeader title="Connect with owner" />
      <TenancyForm
        submitting={createMutation.isPending}
        leading={
          <>
            {connected ? (
              <Text style={styles.connectedCopy}>
                Connected: {connected.ownerName} · {connected.propertyName}
              </Text>
            ) : null}
            <Button
              title={connected ? 'Scan a different owner QR' : 'Scan owner QR'}
              variant="outline"
              onPress={scanConnect}
            />
          </>
        }
        onSubmit={(values) => {
          if (!connected) {
            Toast.error("Scan the owner's QR code");
            return;
          }
          createMutation.mutate({
            ...values,
            property_name: connected.propertyName,
            property_id: connected.propertyId,
          });
        }}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  connectedCopy: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
  },
});
