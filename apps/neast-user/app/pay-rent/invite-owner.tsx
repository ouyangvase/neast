import { useState } from 'react';
import { Linking, ScrollView, StyleSheet, Text } from 'react-native';
import { router } from 'expo-router';
import { useMutation } from '@tanstack/react-query';

import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  spacing,
  TextField,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { sendRentInvite } from '../../src/lib/endpoints';
import { useSelectionStore } from '../../src/stores/selection';
import { Screen } from '../../src/components/Screen';

/**
 * Owner invite (owner_invite_screen parity): name/email/phone form +
 * WhatsApp-style draft message. `POST /app/rent/invite` is mock-only —
 * failure is tolerated and the share sheet still opens.
 */
export default function InviteOwnerRoute() {
  const rent = useSelectionStore((state) => state.rent);
  const history = useSelectionStore((state) => state.history);

  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');

  const inviteMutation = useMutation({
    mutationFn: () =>
      sendRentInvite({
        rent_id: rent?.id ?? history?.rent_id ?? 0,
        history_id: history?.id ?? 0,
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
      }),
  });

  const buildMessage = () =>
    [
      `Hi ${name.trim() || 'there'},`,
      '',
      `I've been paying rent for ${rent?.property_name ?? history?.property_address ?? 'my unit'} through NEAST.`,
      'Join NEAST so you can receive rent payouts directly:',
      'https://neast.my/owner',
    ].join('\n');

  const submit = async () => {
    if (!name.trim() || !phone.trim()) {
      Toast.error('Please enter the owner name and phone');
      return;
    }
    try {
      await inviteMutation.mutateAsync();
      Toast.success('Invitation recorded');
    } catch (error) {
      // Mock-only endpoint — tolerate failure against the real API.
      Toast.info(apiErrorMessage(error, 'Invite unavailable — sharing the message instead.'));
    }
    const digits = phone.replace(/\D/g, '');
    const url = `https://wa.me/${digits}?text=${encodeURIComponent(buildMessage())}`;
    void Linking.openURL(url).catch(() => Toast.error('Could not open the share sheet'));
  };

  return (
    <Screen>
      <BrandHeader title="Invite Owner" onBack={() => router.back()} />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <Card style={styles.formCard}>
          <Text style={styles.title}>Owner details</Text>
          <TextField label="Name" value={name} onChangeText={setName} />
          <TextField
            label="Email"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
          />
          <TextField label="Phone" value={phone} onChangeText={setPhone} keyboardType="phone-pad" />
        </Card>

        <Card style={styles.previewCard}>
          <Text style={styles.title}>Message preview</Text>
          <Text style={styles.previewText}>{buildMessage()}</Text>
        </Card>

        <Button
          title="Send Invite"
          onPress={() => void submit()}
          loading={inviteMutation.isPending}
        />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  formCard: {
    gap: spacing.md,
  },
  previewCard: {
    gap: spacing.sm,
  },
  title: {
    ...textStyles.heading3,
  },
  previewText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
});
