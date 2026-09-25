import { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { Button, spacing, TextField, Toast } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { updateUserProfile } from '../../src/lib/endpoints';
import { useUserProfile } from '../../src/hooks/use-profile';
import { DatePickerField, fromYmd, toYmd } from '../../src/components/DatePickerField';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

/**
 * Single-field editor (personal_data_edit_screen parity). The wire body
 * requires first/last name on every call, so they are merged from the
 * cached profile.
 */
export default function PersonalDataEditRoute() {
  const params = useLocalSearchParams<{ field: string; label: string; value: string }>();
  const field = params.field ?? '';
  const isDateField = field === 'id_valid_until';
  const [value, setValue] = useState(params.value === '-' ? '' : (params.value ?? ''));
  const [dateValue, setDateValue] = useState<Date | null>(
    isDateField ? fromYmd(params.value ?? '') : null,
  );
  const queryClient = useQueryClient();
  const profile = useUserProfile();

  const saveMutation = useMutation({
    mutationFn: () => {
      const user = profile.data;
      return updateUserProfile({
        first_name: field === 'first_name' ? value.trim() : (user?.firstName ?? ''),
        last_name: field === 'last_name' ? value.trim() : (user?.lastName ?? ''),
        email: field === 'email' ? value.trim() : undefined,
        address: field === 'address' ? value.trim() : undefined,
        id_valid_until: isDateField && dateValue ? toYmd(dateValue) : undefined,
      });
    },
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['user-profile'] });
      Toast.success('Saved');
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  return (
    <Screen edges={[]}>
      <PageHeader title={params.label ?? 'Edit'} />
      <View style={styles.body}>
        {isDateField ? (
          <DatePickerField
            label={params.label ?? 'Date'}
            value={dateValue}
            onChange={setDateValue}
          />
        ) : (
          <TextField
            label={params.label ?? 'Value'}
            value={value}
            onChangeText={setValue}
            autoFocus
            keyboardType={field === 'email' ? 'email-address' : 'default'}
            autoCapitalize={field === 'email' ? 'none' : 'sentences'}
          />
        )}
        <Button
          title="Save"
          onPress={() => saveMutation.mutate()}
          loading={saveMutation.isPending}
          style={styles.submit}
        />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  submit: {
    marginTop: spacing.sm,
  },
});
