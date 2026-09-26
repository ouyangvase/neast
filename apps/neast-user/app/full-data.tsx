import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useMutation } from '@tanstack/react-query';

import { ID_TYPE_LABELS } from '@neast/constant';
import type { IdType } from '@neast/types';
import {
  BottomSheet,
  Button,
  coreColors,
  spacing,
  TextField,
  textStyles,
  Toast,
  PageHeader,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { navigateAfterAuth } from '@/lib/auth';
import { updateUserProfile } from '@/lib/endpoints';
import { DatePickerField, toYmd } from '@/components/DatePickerField';
import { Screen } from '@/components/Screen';

/**
 * First-profile form (full_data_screen parity): shown once after signup.
 * Submits POST /app/user/profile with the snake_case wire body.
 */
export default function FullDataRoute() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [invitationCode, setInvitationCode] = useState('');
  const [idType, setIdType] = useState<IdType>('id_card');
  const [idNumber, setIdNumber] = useState('');
  const [idValidUntil, setIdValidUntil] = useState<Date | null>(null);
  const [idTypePickerVisible, setIdTypePickerVisible] = useState(false);

  const saveMutation = useMutation({
    mutationFn: updateUserProfile,
    onSuccess: () => navigateAfterAuth(),
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const submit = () => {
    if (!firstName.trim() || !lastName.trim()) {
      Toast.error('Please enter your first and last name');
      return;
    }
    saveMutation.mutate({
      first_name: firstName.trim(),
      last_name: lastName.trim(),
      email: email.trim() || undefined,
      address: address.trim() || undefined,
      invitation_code: invitationCode.trim() || undefined,
      id_type: idType,
      id_number: idNumber.trim() || undefined,
      id_valid_until: idType === 'passport' && idValidUntil ? toYmd(idValidUntil) : undefined,
    });
  };

  return (
    <Screen edges={[]}>
      <PageHeader title="Complete Your Profile" showBack={false} />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <Text style={styles.subtitle}>
          Tell us a bit about yourself to finish setting up your account.
        </Text>

        <TextField label="First name" value={firstName} onChangeText={setFirstName} />
        <TextField label="Last name" value={lastName} onChangeText={setLastName} />
        <TextField
          label="Email"
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
        />
        <TextField label="Address" value={address} onChangeText={setAddress} />
        <TextField
          label="Invitation code (optional)"
          value={invitationCode}
          onChangeText={setInvitationCode}
          autoCapitalize="characters"
        />

        <Text style={styles.sectionTitle}>ID Document</Text>
        <View>
          <Text style={styles.fieldLabel}>ID type</Text>
          <Pressable
            style={styles.selector}
            onPress={() => setIdTypePickerVisible(true)}
            accessibilityRole="button"
          >
            <Text style={styles.selectorText}>{ID_TYPE_LABELS[idType]}</Text>
          </Pressable>
        </View>
        <TextField label="ID number" value={idNumber} onChangeText={setIdNumber} />
        {idType === 'passport' ? (
          <DatePickerField label="ID valid until" value={idValidUntil} onChange={setIdValidUntil} />
        ) : null}

        <Button
          title="Save & Continue"
          onPress={submit}
          loading={saveMutation.isPending}
          style={styles.submit}
        />
      </ScrollView>

      <BottomSheet
        visible={idTypePickerVisible}
        onClose={() => setIdTypePickerVisible(false)}
        title="ID type"
      >
        {(Object.keys(ID_TYPE_LABELS) as IdType[]).map((value) => (
          <Pressable
            key={value}
            style={styles.option}
            onPress={() => {
              setIdType(value);
              setIdTypePickerVisible(false);
            }}
            accessibilityRole="button"
          >
            <Text style={styles.optionText}>{ID_TYPE_LABELS[value]}</Text>
          </Pressable>
        ))}
      </BottomSheet>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
  },
  subtitle: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  sectionTitle: {
    ...textStyles.heading3,
    marginTop: spacing.sm,
  },
  fieldLabel: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    marginBottom: spacing.sm,
  },
  selector: {
    borderWidth: 1,
    borderColor: coreColors.border,
    borderRadius: 8,
    backgroundColor: coreColors.white,
    paddingHorizontal: spacing.md,
    minHeight: 48,
    justifyContent: 'center',
  },
  selectorText: {
    ...textStyles.body,
  },
  option: {
    paddingVertical: spacing.md,
  },
  optionText: {
    ...textStyles.body,
  },
  submit: {
    marginTop: spacing.lg,
  },
});
