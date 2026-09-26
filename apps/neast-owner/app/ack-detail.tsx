import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import {
  Button,
  Card,
  coreColors,
  PageHeader,
  spacing,
  textStyles,
  Toast,
  userHomeColors,
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
      <Screen edges={[]}>
        <PageHeader title="Confirm Receipt" />
        <ErrorState message="Record unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  return (
    <Screen edges={[]}>
      <PageHeader title="Confirm Receipt" />
      <View style={styles.body}>
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
      </View>
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
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
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
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.body,
    fontWeight: '700',
    color: userHomeColors.navy,
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
    color: userHomeColors.navy,
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
    color: userHomeColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
  agreementLink: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
});
