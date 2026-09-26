import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { ID_TYPE_LABELS } from '@neast/constant';
import type { IdType, UserProfile } from '@neast/types';
import { Button, Card, spacing, TextField, Toast, userHomeColors } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { updateUserProfile } from '@/lib/endpoints';
import { useUserProfile } from '@/hooks/use-profile';
import { DatePickerField, fromYmd, toYmd } from '@/components/DatePickerField';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';
import { ErrorState, LoadingState } from '@/components/StateViews';

function DetailRow({
  label,
  value,
  bordered,
}: {
  label: string;
  value: string | null;
  bordered?: boolean;
}) {
  return (
    <View style={[styles.row, bordered && styles.rowBorder]}>
      <Text style={styles.rowLabel}>{label}</Text>
      <Text style={styles.rowValue}>{value}</Text>
    </View>
  );
}

function LockedField({ label, value }: { label: string; value: string | null }) {
  return (
    <View style={styles.locked}>
      <Text style={styles.lockedLabel}>{label}</Text>
      <View style={styles.lockedBox}>
        <Text style={styles.lockedValue}>{value}</Text>
      </View>
    </View>
  );
}

/** Profile details. Edit saves the full writable set in place. */
export default function PersonalDataRoute() {
  const insets = useSafeAreaInsets();
  const profile = useUserProfile();
  const queryClient = useQueryClient();
  const user = profile.data;
  const isPassport = user?.idType === 'passport';
  const [editing, setEditing] = useState(false);
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [passportUntil, setPassportUntil] = useState<Date | null>(null);

  const saveMutation = useMutation({
    mutationFn: () =>
      updateUserProfile({
        first_name: firstName.trim(),
        last_name: lastName.trim(),
        email: email.trim(),
        address: address.trim(),
        id_valid_until: isPassport && passportUntil ? toYmd(passportUntil) : undefined,
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['user-profile'] });
      Toast.success('Saved');
      setEditing(false);
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const startEdit = (current: UserProfile) => {
    setFirstName(current.firstName);
    setLastName(current.lastName);
    setEmail(current.email ?? '');
    setAddress(current.address ?? '');
    setPassportUntil(fromYmd(current.idValidUntil));
    setEditing(true);
  };

  const save = () => {
    if (!firstName.trim() || !lastName.trim()) {
      Toast.error('Please enter your first and last name');
      return;
    }
    if (isPassport && !passportUntil) {
      Toast.error('Please select the valid until date');
      return;
    }
    saveMutation.mutate();
  };

  const rows: { label: string; value: string | null }[] = user
    ? [
        { label: 'First name', value: user.firstName },
        { label: 'Last name', value: user.lastName },
        { label: 'Email', value: user.email },
        { label: 'Phone', value: `+${user.account}` },
        { label: 'Address', value: user.address },
        { label: 'ID type', value: ID_TYPE_LABELS[user.idType as IdType] },
        { label: 'ID number', value: user.idNumber },
        ...(isPassport
          ? [{ label: 'Passport valid until', value: user.idValidUntil }]
          : []),
      ]
    : [];

  return (
    <Screen edges={[]}>
      <PageHeader
        title="Personal Information"
        right={
          user ? (
            editing ? (
              <Pressable
                accessibilityRole="button"
                accessibilityLabel="Cancel"
                hitSlop={8}
                onPress={() => setEditing(false)}
              >
                <Text style={styles.cancel}>Cancel</Text>
              </Pressable>
            ) : (
              <Pressable
                accessibilityRole="button"
                accessibilityLabel="Edit"
                hitSlop={8}
                onPress={() => startEdit(user)}
              >
                <Ionicons name="create-outline" size={22} color={userHomeColors.surface} />
              </Pressable>
            )
          ) : null
        }
      />
      {profile.isLoading ? (
        <LoadingState />
      ) : !user ? (
        <ErrorState onRetry={() => profile.refetch()} />
      ) : (
        <View style={styles.body}>
          <ScrollView
            keyboardShouldPersistTaps="handled"
            contentContainerStyle={[
              styles.scroll,
              { paddingBottom: editing ? spacing.lg : insets.bottom + spacing.lg },
            ]}
          >
            <Card padded={false} style={styles.card}>
              {editing ? (
                <View style={styles.form}>
                  <TextField label="First name" value={firstName} onChangeText={setFirstName} />
                  <TextField label="Last name" value={lastName} onChangeText={setLastName} />
                  <TextField
                    label="Email"
                    value={email}
                    onChangeText={setEmail}
                    keyboardType="email-address"
                    autoCapitalize="none"
                  />
                  <LockedField label="Phone" value={`+${user.account}`} />
                  <TextField label="Address" value={address} onChangeText={setAddress} multiline />
                  <LockedField label="ID type" value={ID_TYPE_LABELS[user.idType as IdType]} />
                  <LockedField label="ID number" value={user.idNumber} />
                  {isPassport ? (
                    <DatePickerField
                      label="Passport valid until"
                      value={passportUntil}
                      onChange={setPassportUntil}
                    />
                  ) : null}
                </View>
              ) : (
                rows.map((row, index) => (
                  <DetailRow
                    key={row.label}
                    label={row.label}
                    value={row.value}
                    bordered={index > 0}
                  />
                ))
              )}
            </Card>
          </ScrollView>
          {editing ? (
            <View style={[styles.footer, { paddingBottom: insets.bottom + spacing.md }]}>
              <Button title="Save" onPress={save} loading={saveMutation.isPending} />
            </View>
          ) : null}
        </View>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  cancel: {
    color: userHomeColors.surface,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scroll: {
    flexGrow: 1,
  },
  card: {
    margin: spacing.lg,
    overflow: 'hidden',
  },
  row: {
    paddingHorizontal: 20,
    paddingVertical: 14,
    gap: 4,
    backgroundColor: userHomeColors.surface,
  },
  rowBorder: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: userHomeColors.border,
  },
  rowLabel: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
  },
  rowValue: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
    fontWeight: '600',
  },
  form: {
    padding: spacing.lg,
    gap: spacing.lg,
  },
  locked: {
    gap: spacing.sm,
  },
  lockedLabel: {
    color: userHomeColors.textPrimary,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '500',
  },
  lockedBox: {
    minHeight: 48,
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    borderRadius: 8,
    backgroundColor: userHomeColors.background,
  },
  lockedValue: {
    color: userHomeColors.textPrimary,
    fontSize: 16,
    lineHeight: 22,
  },
  footer: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    backgroundColor: userHomeColors.background,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: userHomeColors.border,
  },
});
