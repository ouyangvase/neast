import { useState } from 'react';
import { Linking, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Redirect } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { Button, TextField, Toast, userHomeColors } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { saveOwnerContact } from '../../src/lib/endpoints';
import { useSelectionStore } from '../../src/stores/selection';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

/** Invite an owner who is not a NEAST landlord. Opened from an unlinked tenancy card. */
export default function InviteOwnerRoute() {
  const queryClient = useQueryClient();
  const rent = useSelectionStore((state) => state.rent);

  const [name, setName] = useState(rent?.landlord_name ?? '');
  const [email, setEmail] = useState(rent?.owner_email ?? '');
  const [phone, setPhone] = useState(rent?.owner_phone ?? '');

  const saveMutation = useMutation({
    mutationFn: () =>
      saveOwnerContact(rent!.id, {
        owner_name: name.trim(),
        owner_email: email.trim(),
        owner_phone: phone.trim(),
      }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['rent-list'] }),
  });

  if (!rent) {
    return <Redirect href="/" />;
  }

  const message = [
    `Hi ${name.trim()},`,
    '',
    `I've been paying rent for ${rent.property_name} through NEAST.`,
    'Join NEAST so you can receive rent payouts directly:',
    'https://neast.my/owner',
  ].join('\n');

  const send = async (channel: 'email' | 'whatsapp') => {
    if (!name.trim()) {
      Toast.error('Please enter the owner name');
      return;
    }
    if (channel === 'email' && !email.trim()) {
      Toast.error('Please enter the owner email');
      return;
    }
    if (channel === 'whatsapp' && !phone.trim()) {
      Toast.error('Please enter the owner phone');
      return;
    }
    try {
      await saveMutation.mutateAsync();
    } catch (error) {
      Toast.error(apiErrorMessage(error));
      return;
    }
    const url =
      channel === 'email'
        ? `mailto:${email.trim()}?subject=${encodeURIComponent('Join NEAST')}&body=${encodeURIComponent(message)}`
        : `https://wa.me/${phone.replace(/\D/g, '')}?text=${encodeURIComponent(message)}`;
    void Linking.openURL(url).catch(() => Toast.error('Could not open the share sheet'));
  };

  return (
    <Screen edges={[]}>
      <PageHeader title="Connect with owner" />
      <ScrollView
        keyboardShouldPersistTaps="handled"
        style={styles.scroll}
        contentContainerStyle={styles.content}
      >
        <View style={styles.card}>
          <Text style={styles.label}>Relationship to property</Text>
          <Text style={styles.relationship}>Owner</Text>
          <TextField label="Owner name" value={name} onChangeText={setName} />
          <TextField
            label="Email"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
          />
          <TextField label="Phone" value={phone} onChangeText={setPhone} keyboardType="phone-pad" />
        </View>
        <Button title="Email" onPress={() => void send('email')} loading={saveMutation.isPending} />
        <Button
          title="WhatsApp"
          variant="outline"
          onPress={() => void send('whatsapp')}
          loading={saveMutation.isPending}
        />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  content: {
    padding: 14,
    gap: 12,
    paddingBottom: 32,
  },
  card: {
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    padding: 16,
    gap: 12,
  },
  label: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 17,
  },
  relationship: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 21,
    fontWeight: '600',
  },
});
