import { useState } from 'react';
import { Linking, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Redirect } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { Button, MailIcon, TextField, Toast, userHomeColors, WhatsAppIcon } from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { saveOwnerContact } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

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
          <Text style={styles.cardTitle}>Invite the owner</Text>
          <Text style={styles.cardCopy}>Add their contact and send an invite.</Text>
          <TextField
            label="Name"
            value={name}
            onChangeText={setName}
            placeholder="Owner's name"
          />
          <TextField
            label="Email"
            value={email}
            onChangeText={setEmail}
            placeholder="name@email.com"
            keyboardType="email-address"
            autoCapitalize="none"
          />
          <TextField
            label="Phone"
            value={phone}
            onChangeText={setPhone}
            placeholder="Phone number"
            keyboardType="phone-pad"
          />
        </View>
        <View style={styles.actions}>
          <Button
            title="Email"
            variant="secondary"
            fullWidth={false}
            style={styles.action}
            icon={<MailIcon size={20} color={userHomeColors.surface} />}
            onPress={() => void send('email')}
            loading={saveMutation.isPending}
          />
          <Button
            title="WhatsApp"
            variant="secondary"
            fullWidth={false}
            style={styles.action}
            icon={<WhatsAppIcon size={20} />}
            onPress={() => void send('whatsapp')}
            loading={saveMutation.isPending}
          />
        </View>
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
  cardTitle: {
    color: userHomeColors.textPrimary,
    fontSize: 17,
    lineHeight: 22,
    fontWeight: '700',
  },
  cardCopy: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  actions: {
    flexDirection: 'row',
    gap: 12,
  },
  action: {
    flex: 1,
  },
});
