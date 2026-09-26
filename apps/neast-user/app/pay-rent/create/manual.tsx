import { useState } from 'react';
import { ActivityIndicator, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { JourneyBar, TextField, Toast, userHomeColors } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../../src/lib/api';
import { createRent } from '../../../src/lib/endpoints';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';
import { TenancyForm, type TenancyFormValues } from '../../../src/features/pay-rent/tenancy-form';

/** Manual path: tenancy details, then the non-NEAST owner's payout bank. */
export default function ManualTenancyRoute() {
  const queryClient = useQueryClient();
  const [step, setStep] = useState(0);
  const [propertyName, setPropertyName] = useState('');
  const [ownerName, setOwnerName] = useState('');
  const [details, setDetails] = useState<TenancyFormValues | null>(null);
  const [bankName, setBankName] = useState('');
  const [bankAccount, setBankAccount] = useState('');
  const [accountHolder, setAccountHolder] = useState('');

  const createMutation = useMutation({
    mutationFn: createRent,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      Toast.success('Tenancy submitted for review');
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
    createMutation.mutate({
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
      <PageHeader title="Add manually" onBack={step === 1 ? () => setStep(0) : undefined} />
      <JourneyBar steps={['Details', 'Payout']} activeIndex={step} />
      <View style={step === 0 ? styles.step : styles.hidden}>
        <TenancyForm
          submitting={false}
          submitLabel="Next"
          leading={
            <>
              <TextField label="Property name" value={propertyName} onChangeText={setPropertyName} />
              <TextField label="Owner name" value={ownerName} onChangeText={setOwnerName} />
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
          submitting={createMutation.isPending}
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
  onSubmit,
}: {
  bankName: string;
  bankAccount: string;
  accountHolder: string;
  onBankName: (value: string) => void;
  onBankAccount: (value: string) => void;
  onAccountHolder: (value: string) => void;
  submitting: boolean;
  onSubmit: () => void;
}) {
  const insets = useSafeAreaInsets();

  return (
    <View style={styles.step}>
      <ScrollView
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={[styles.scroll, { paddingBottom: insets.bottom + 78 }]}
      >
        <Text style={styles.copy}>Where should this rent be paid out?</Text>
        <TextField label="Bank name" value={bankName} onChangeText={onBankName} />
        <TextField
          label="Account number"
          value={bankAccount}
          onChangeText={onBankAccount}
          keyboardType="number-pad"
        />
        <TextField label="Account holder" value={accountHolder} onChangeText={onAccountHolder} />
      </ScrollView>
      <Pressable
        accessibilityRole="button"
        disabled={submitting}
        onPress={onSubmit}
        style={({ pressed }) => [
          styles.submit,
          { bottom: insets.bottom + 16 },
          pressed && styles.pressed,
        ]}
      >
        {submitting ? (
          <ActivityIndicator color={userHomeColors.surface} />
        ) : (
          <Text style={styles.submitText}>Submit</Text>
        )}
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  step: {
    flex: 1,
  },
  hidden: {
    display: 'none',
  },
  scroll: {
    padding: 16,
    gap: 12,
  },
  copy: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  submit: {
    position: 'absolute',
    left: 14,
    right: 14,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  submitText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
  },
});
