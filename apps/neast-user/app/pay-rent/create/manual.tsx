import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import type { CreateRentBody } from '@neast/types';
import { Button, Card, JourneyBar, spacing, TextField, Toast, userHomeColors } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { createRent, updateRent } from '@/lib/endpoints';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';
import { TenancyForm, type TenancyFormValues } from '@/features/pay-rent/tenancy-form';
import { useSelectionStore } from '@/stores/selection';

/** Manual path: tenancy details, then the non-NEAST owner's payout bank. */
export default function ManualTenancyRoute() {
  const queryClient = useQueryClient();
  const params = useLocalSearchParams<{ rentId?: string }>();
  const stored = useSelectionStore((state) => state.rent);
  const editing = params.rentId && stored?.id === Number(params.rentId) ? stored : null;
  const [step, setStep] = useState(0);
  const [propertyName, setPropertyName] = useState(editing?.property_name ?? '');
  const [ownerName, setOwnerName] = useState(editing?.owner_name ?? '');
  const [details, setDetails] = useState<TenancyFormValues | null>(null);
  const [bankName, setBankName] = useState(editing?.landlord_bank ?? '');
  const [bankAccount, setBankAccount] = useState(editing?.landlord_bank_account ?? '');
  const [accountHolder, setAccountHolder] = useState(editing?.landlord_account_name ?? '');

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

  const submit = () => {
    if (!details) return;
    if (!bankName.trim()) {
      Toast.error('Please enter the bank name');
      return;
    }
    if (!bankAccount.trim()) {
      Toast.error('Please enter the account number');
      return;
    }
    if (!accountHolder.trim()) {
      Toast.error('Please enter the account holder');
      return;
    }
    saveMutation.mutate({
      ...details,
      property_name: propertyName.trim(),
      owner_name: ownerName.trim(),
      landlord_bank: bankName.trim(),
      landlord_bank_account: bankAccount.trim(),
      landlord_account_name: accountHolder.trim(),
    });
  };

  return (
    <Screen edges={[]}>
      <PageHeader
        title={editing ? 'Edit tenancy' : 'Add manually'}
        onBack={step === 1 ? () => setStep(0) : undefined}
      />
      <JourneyBar steps={['Details', 'Payout']} activeIndex={step} />
      <View style={step === 0 ? styles.step : styles.hidden}>
        <TenancyForm
          submitting={false}
          submitLabel="Next"
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
              <TextField
                label="Property name"
                value={propertyName}
                onChangeText={setPropertyName}
                placeholder="Apartment or house name"
              />
              <TextField
                label="Owner name"
                value={ownerName}
                onChangeText={setOwnerName}
                placeholder="Name on the agreement"
              />
            </>
          }
          onSubmit={(values) => {
            if (!propertyName.trim()) {
              Toast.error('Please enter the property name');
              return;
            }
            if (!ownerName.trim()) {
              Toast.error('Please enter the owner name');
              return;
            }
            setDetails(values);
            setStep(1);
          }}
        />
      </View>
      {step === 1 ? (
        <PayoutStep
          bankName={bankName}
          bankAccount={bankAccount}
          accountHolder={accountHolder}
          onBankName={setBankName}
          onBankAccount={setBankAccount}
          onAccountHolder={setAccountHolder}
          submitting={saveMutation.isPending}
          submitLabel={editing ? 'Save' : 'Submit'}
          onSubmit={submit}
        />
      ) : null}
    </Screen>
  );
}

function PayoutStep({
  bankName,
  bankAccount,
  accountHolder,
  onBankName,
  onBankAccount,
  onAccountHolder,
  submitting,
  submitLabel,
  onSubmit,
}: {
  bankName: string;
  bankAccount: string;
  accountHolder: string;
  onBankName: (value: string) => void;
  onBankAccount: (value: string) => void;
  onAccountHolder: (value: string) => void;
  submitting: boolean;
  submitLabel: string;
  onSubmit: () => void;
}) {
  const insets = useSafeAreaInsets();

  return (
    <View style={styles.step}>
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <Card style={styles.fields}>
          <Text style={styles.copy}>Where should this rent be paid out?</Text>
          <TextField label="Bank name" value={bankName} onChangeText={onBankName} />
          <TextField
            label="Account number"
            value={bankAccount}
            onChangeText={onBankAccount}
            keyboardType="number-pad"
          />
          <TextField
            label="Account holder"
            value={accountHolder}
            onChangeText={onAccountHolder}
            placeholder="Name on the account"
          />
        </Card>
      </ScrollView>
      <View style={[styles.footer, { paddingBottom: insets.bottom + spacing.md }]}>
        <Button title={submitLabel} onPress={onSubmit} loading={submitting} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  step: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  hidden: {
    display: 'none',
  },
  scroll: {
    padding: spacing.lg,
  },
  fields: {
    gap: spacing.lg,
  },
  copy: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  footer: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    backgroundColor: userHomeColors.background,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: userHomeColors.border,
  },
});
