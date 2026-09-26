import { Image, RefreshControl, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatRinggit } from '@neast/types';
import {
  Card,
  coreColors,
  GradientHeader,
  ownerAccentColors,
  spacing,
  textStyles,
  useUiTheme,
} from '@neast/ui-mobile';

import { getPortfolioDetail } from '@/lib/endpoints';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Portfolio snapshot (portfolio_snapshot_screen parity): rent roll + tenant list drill-down. */
export default function PortfolioSnapshotRoute() {
  const theme = useUiTheme();
  const portfolio = useQuery({ queryKey: ['portfolio'], queryFn: getPortfolioDetail });

  const data = portfolio.data;

  return (
    <Screen edges={[]}>
      <GradientHeader
        colors={theme.gradients.header}
        title="Portfolio"
        lightContent={false}
        onBack={() => router.back()}
      >
        <Text style={styles.rentRollLabel}>Rent roll this month</Text>
        <Text style={styles.rentRollValue}>{formatRinggit(data?.rent_roll ?? 0)}</Text>
        <Text style={styles.tenantCount}>{data?.tenant_count ?? 0} tenants</Text>
      </GradientHeader>

      {portfolio.isLoading ? (
        <LoadingState />
      ) : portfolio.isError || !data ? (
        <ErrorState onRetry={() => portfolio.refetch()} />
      ) : (
        <ScrollView
          contentContainerStyle={styles.scroll}
          refreshControl={
            <RefreshControl
              refreshing={portfolio.isRefetching}
              onRefresh={() => portfolio.refetch()}
              colors={[coreColors.actionGreen]}
              tintColor={coreColors.actionGreen}
            />
          }
        >
          {data.tenants.length === 0 ? (
            <Text style={styles.empty}>No active tenants yet.</Text>
          ) : (
            data.tenants.map((tenant) => (
              <Card
                key={tenant.id}
                style={styles.tenantRow}
                onPress={() =>
                  router.push({ pathname: '/portfolio-tenant-detail', params: { id: tenant.id } })
                }
              >
                {tenant.avatar ? (
                  <Image source={{ uri: tenant.avatar }} style={styles.avatar} />
                ) : (
                  <View style={[styles.avatar, styles.avatarFallback]}>
                    <Text style={styles.avatarText}>{tenant.initials}</Text>
                  </View>
                )}
                <View style={styles.tenantBody}>
                  <Text style={styles.tenantName} numberOfLines={1}>
                    {tenant.name}
                  </Text>
                  <Text style={styles.tenantAddress} numberOfLines={1}>
                    {tenant.address}
                  </Text>
                </View>
              </Card>
            ))
          )}
        </ScrollView>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  rentRollLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.lg,
  },
  rentRollValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: spacing.xs,
  },
  tenantCount: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
  scroll: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
  },
  empty: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xl,
  },
  tenantRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  avatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
  },
  avatarFallback: {
    backgroundColor: ownerAccentColors.surfaceBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  tenantBody: {
    flex: 1,
  },
  tenantName: {
    ...textStyles.body,
    fontWeight: '600',
  },
  tenantAddress: {
    ...textStyles.caption,
    marginTop: 2,
  },
});
