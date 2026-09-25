import { useState } from 'react';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { TextField, Toast } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../../src/lib/api';
import { createRent } from '../../../src/lib/endpoints';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';
import { TenancyForm } from '../../../src/features/pay-rent/tenancy-form';

/** Manual path: typed property and owner, then the shared tenancy fields. */
export default function ManualTenancyRoute() {
  const queryClient = useQueryClient();
  const [propertyName, setPropertyName] = useState('');
  const [ownerName, setOwnerName] = useState('');

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
      <PageHeader title="Add manually" />
      <TenancyForm
        submitting={createMutation.isPending}
        leading={
          <>
            <TextField label="Property name" value={propertyName} onChangeText={setPropertyName} />
            <TextField label="Owner name" value={ownerName} onChangeText={setOwnerName} />
          </>
        }
        onSubmit={(values) => {
          createMutation.mutate({
            ...values,
            property_name: propertyName,
            owner_name: ownerName,
          });
        }}
      />
    </Screen>
  );
}
