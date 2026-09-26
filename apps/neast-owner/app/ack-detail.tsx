import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  ownerAccentColors,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { confirmAck } from '@/lib/endpoints';
import { useFileViewer } from '@/hooks/use-file-viewer';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Ack detail (ack_detail_screen parity): confirm receipt of a settled rent payment. */
export default function AckDetailRoute() {
  const item = useSelectionStore((state) => state.ackItem);
  const queryClient = useQueryClient();
  const fileViewer = useFileViewer();

  const confirmMutation = useMutation({
    mutationFn: () => confirmAck(item!.id),
    onSuccess: async () => {
      Toast.success('Receipt confirmed');
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['ack-list'] }),
        queryClient.invalidateQueries({ queryKey: ['home-dashboard'] }),
      ]);
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  if (!item) {
    return (
      <Screen>
        <BrandHeader title="Confirm Receipt" onBack={() => router.back()} />
        <ErrorState message="Record unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  return (
    <Screen>
      <BrandHeader title="Confirm Receipt" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.scroll}>
        <Card style={styles.card}>
          <View style={styles.titleRow}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.initials}</Text>
            </View>
            <View style={styles.titleTexts}>
              <Text style={styles.name} numberOfLines={1}>
                {item.name}
              </Text>
              <Text style={styles.paidText}>{item.paid_text}</Text>
            </View>
          </View>
          <Text style={styles.amount}>RM{item.amount}</Text>
          <View style={styles.infoRows}>
            <InfoRow label="Property" value={item.property_name || item.property_address} />
            <InfoRow label="Rental date" value={item.rental_date} />
            <InfoRow label="Paid on" value={item.paid_date} />
          </View>
          <Pressable onPress={() => fileViewer.open(item.file_url)} accessibilityRole="button">
            <Text style={styles.agreementLink}>View tenancy agreement</Text>
          </Pressable>
        </Card>

        <Button
          title="Confirm Receipt"
          onPress={() => confirmMutation.mutate()}
          loading={confirmMutation.isPending}
        />
      </ScrollView>
      {fileViewer.preview}
    </Screen>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
  },
  card: {
    gap: spacing.sm,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: ownerAccentColors.surfaceBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.body,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  titleTexts: {
    flex: 1,
  },
  name: {
    ...textStyles.heading3,
  },
  paidText: {
    ...textStyles.caption,
    color: coreColors.darkGreen,
    marginTop: 2,
  },
  amount: {
    ...textStyles.heading1,
    color: coreColors.brandBlue,
  },
  infoRows: {
    gap: spacing.xs,
    marginTop: spacing.xs,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  infoLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
  agreementLink: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
});
