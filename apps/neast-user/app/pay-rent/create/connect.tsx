import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import type { CreateRentBody } from '@neast/types';
import { Chevron, QrCodeIcon, Toast, userHomeColors, PageHeader } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { openScanner } from '@/lib/callbacks';
import { createRent, getRentPropertyBySn, updateRent } from '@/lib/endpoints';
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
                agreementStart: editing.agreement_start,
                agreementEnd: editing.agreement_end,
                firstPayMonth: editing.first_pay_month,
                file: editing.file,
              }
            : undefined
        }
        leading={
          connected ? (
            <View style={styles.connected}>
              <Text style={styles.eyebrow}>Connected</Text>
              <Text style={styles.propertyName}>{connected.propertyName}</Text>
              <Text style={styles.ownerName}>{connected.ownerName}</Text>
              <Pressable
                accessibilityRole="button"
                onPress={scanConnect}
                style={({ pressed }) => [styles.rescan, pressed && styles.pressed]}
              >
                <Text style={styles.rescanText}>Scan a different owner QR</Text>
                <Chevron direction="right" color={userHomeColors.navy} size={8} />
              </Pressable>
            </View>
          ) : (
            <Pressable
              accessibilityRole="button"
              onPress={scanConnect}
              style={({ pressed }) => [styles.scanRow, pressed && styles.pressed]}
            >
              <View style={styles.iconWell}>
                <QrCodeIcon size={22} color={userHomeColors.navy} />
              </View>
              <View style={styles.scanCopy}>
                <Text style={styles.scanTitle}>Scan owner QR</Text>
                <Text style={styles.scanSubtitle}>Link a property already on NEAST</Text>
              </View>
              <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
            </Pressable>
          )
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
  scanRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    minHeight: 72,
    paddingHorizontal: 12,
    paddingVertical: 12,
    borderRadius: 12,
    backgroundColor: userHomeColors.background,
  },
  iconWell: {
    width: 44,
    height: 44,
    borderRadius: 12,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scanCopy: {
    flex: 1,
    gap: 2,
  },
  scanTitle: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
    fontWeight: '600',
  },
  scanSubtitle: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
  },
  connected: {
    gap: 2,
    padding: 12,
    borderRadius: 12,
    backgroundColor: userHomeColors.background,
  },
  eyebrow: {
    color: userHomeColors.navy,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '700',
  },
  propertyName: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
    fontWeight: '700',
  },
  ownerName: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  rescan: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    gap: 6,
    marginTop: 8,
  },
  rescanText: {
    color: userHomeColors.navy,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
  },
});
