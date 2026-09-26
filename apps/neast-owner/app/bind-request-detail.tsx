import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import type { AuditBindRequestBody } from '@neast/types';
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
import { auditBindRequest } from '@/lib/endpoints';
import { useFileViewer } from '@/hooks/use-file-viewer';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Bind request detail (bind_request_detail_screen parity): approve / reject a tenant bind. */
export default function BindRequestDetailRoute() {
  const item = useSelectionStore((state) => state.bindRequest);
  const queryClient = useQueryClient();
  const fileViewer = useFileViewer();

  const auditMutation = useMutation({
    mutationFn: (result: AuditBindRequestBody['result']) =>
      auditBindRequest({ id: item!.id, result }),
    onSuccess: async (_data, result) => {
      Toast.success(result === 'approved' ? 'Request approved' : 'Request rejected');
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['bind-request-list'] }),
        queryClient.invalidateQueries({ queryKey: ['home-dashboard'] }),
      ]);
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  if (!item) {
    return (
      <Screen>
        <BrandHeader title="Bind Request" onBack={() => router.back()} />
        <ErrorState message="Request unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  return (
    <Screen>
      <BrandHeader title="Bind Request" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.scroll}>
        <Card style={styles.card}>
          <View style={styles.titleRow}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.initials}</Text>
            </View>
            <View style={styles.titleTexts}>
              <Text style={styles.name} numberOfLines={1}>
                {item.user_name}
              </Text>
              <Text style={styles.applied}>Applied {item.rental_date}</Text>
            </View>
          </View>
          <Text style={styles.amount}>RM{item.rent} / month</Text>
          <View style={styles.infoRows}>
            <InfoRow label="Property" value={item.property_name || item.property_address} />
            <InfoRow label="Pay day" value={item.payday} />
          </View>
          <Pressable onPress={() => fileViewer.open(item.file_url)} accessibilityRole="button">
            <Text style={styles.agreementLink}>View tenancy agreement</Text>
          </Pressable>
        </Card>

        <Button
          title="Approve"
          onPress={() => auditMutation.mutate('approved')}
          loading={auditMutation.isPending}
        />
        <Button
          title="Reject"
          variant="outline"
          onPress={() => auditMutation.mutate('rejected')}
          disabled={auditMutation.isPending}
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
  applied: {
    ...textStyles.caption,
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
