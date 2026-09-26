import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { formatSimpleDate } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  CountdownConfirmDialog,
  ownerAccentColors,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { getRentDetail, terminateRent } from '@/lib/endpoints';
import { useFileViewer } from '@/hooks/use-file-viewer';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Tenant lease detail (portfolio_tenant_detail_screen parity): lease view + terminate. */
export default function PortfolioTenantDetailRoute() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const rentId = Number(id);
  const queryClient = useQueryClient();
  const fileViewer = useFileViewer();
  const [terminateVisible, setTerminateVisible] = useState(false);

  const detail = useQuery({
    queryKey: ['rent-detail', rentId],
    queryFn: () => getRentDetail(rentId),
    enabled: Number.isFinite(rentId) && rentId > 0,
  });

  const terminateMutation = useMutation({
    mutationFn: () => terminateRent(rentId),
    onSuccess: async () => {
      Toast.success('Tenancy terminated');
      await queryClient.invalidateQueries({ queryKey: ['portfolio'] });
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const item = detail.data;

  return (
    <Screen>
      <BrandHeader title="Tenant Lease" onBack={() => router.back()} />
      {detail.isLoading ? (
        <LoadingState />
      ) : detail.isError || !item ? (
        <ErrorState onRetry={() => detail.refetch()} />
      ) : (
        <ScrollView contentContainerStyle={styles.scroll}>
          <Card style={styles.card}>
            <View style={styles.titleRow}>
              {item.tenant_avatar ? (
                <Image source={{ uri: item.tenant_avatar }} style={styles.avatar} />
              ) : (
                <View style={[styles.avatar, styles.avatarFallback]}>
                  <Text style={styles.avatarText}>{item.tenant_initials}</Text>
                </View>
              )}
              <View style={styles.titleTexts}>
                <Text style={styles.name} numberOfLines={1}>
                  {item.tenant_name}
                </Text>
                <Text style={styles.property} numberOfLines={1}>
                  {item.property_name || item.property_address}
                </Text>
              </View>
            </View>
            <Text style={styles.amount}>RM{item.amount} / month</Text>
            <View style={styles.infoRows}>
              <InfoRow label="Pay day" value={`Day ${item.paid_at}`} />
              <InfoRow label="First payment" value={item.first_pay_month} />
              <InfoRow label="Lease" value={`${item.lease_months} months`} />
              <InfoRow label="Expires" value={formatSimpleDate(item.expire_date)} />
              <InfoRow label="Started" value={formatSimpleDate(item.created_at)} />
            </View>
            <Pressable onPress={() => fileViewer.open(item.file_url)} accessibilityRole="button">
              <Text style={styles.agreementLink}>View tenancy agreement</Text>
            </Pressable>
          </Card>

          {item.can_terminate ? (
            <Button
              title="Terminate Tenancy"
              variant="outline"
              onPress={() => setTerminateVisible(true)}
            />
          ) : null}
        </ScrollView>
      )}

      <CountdownConfirmDialog
        visible={terminateVisible}
        title="Terminate tenancy?"
        message="This ends the tenancy and cancels pending rent payments. This cannot be undone."
        countdownSeconds={5}
        confirmText="Terminate"
        onConfirm={() => {
          setTerminateVisible(false);
          terminateMutation.mutate();
        }}
        onCancel={() => setTerminateVisible(false)}
      />
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
  },
  avatarFallback: {
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
  property: {
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
