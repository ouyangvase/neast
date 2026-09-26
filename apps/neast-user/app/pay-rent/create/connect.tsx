import { useState } from 'react';
import { StyleSheet, Text } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import type { CreateRentBody } from '@neast/types';
import { Button, coreColors, textStyles, Toast } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { openScanner } from '@/lib/callbacks';
import { createRent, getRentPropertyBySn, updateRent } from '@/lib/endpoints';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';
import { TenancyForm } from '@/features/pay-rent/tenancy-form';
import { useSelectionStore } from '@/stores/selection';

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
    rentId?: string;
  }>();
  const stored = useSelectionStore((state) => state.rent);
  const editing = params.rentId && stored?.id === Number(params.rentId) ? stored : null;
  const [connected, setConnected] = useState<ConnectedProperty | null>(
    params.propertyName
      ? {
          propertyId: Number(params.propertyId),
          propertyName: params.propertyName,
          ownerName: params.ownerName ?? '',
        }
      : editing?.property_id
        ? {
            propertyId: editing.property_id,
            propertyName: editing.property_name,
            ownerName: editing.landlord_name,
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

  const saveMutation = useMutation({
    mutationFn: (body: CreateRentBody) =>
      editing ? updateRent(editing.id, body) : createRent(body),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      Toast.success(editing ? 'Tenancy updated' : 'Tenancy submitted for review');
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  return (
    <Screen edges={[]}>
      <PageHeader title={editing ? 'Edit tenancy' : 'Connect with owner'} />
      <TenancyForm
        submitting={saveMutation.isPending}
        submitLabel={editing ? 'Save' : 'Submit'}
        initial={
          editing
            ? {
                amount: editing.amount,
                paidAt: Number(editing.paid_at),
                firstPayMonth: editing.first_pay_month,
                leaseMonths: editing.lease_months,
                file: editing.file,
              }
            : undefined
        }
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
          saveMutation.mutate({
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
