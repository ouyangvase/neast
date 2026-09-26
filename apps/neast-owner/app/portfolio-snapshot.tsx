import { Image, RefreshControl, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatRinggit } from '@neast/types';
import { Card, PageHeader, spacing, textStyles, userHomeColors } from '@neast/ui-mobile';

import { getPortfolioDetail } from '@/lib/endpoints';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Portfolio snapshot: rent roll and tenant list. */
export default function PortfolioSnapshotRoute() {
  const portfolio = useQuery({ queryKey: ['portfolio'], queryFn: getPortfolioDetail });
  const data = portfolio.data;

  return (
    <Screen edges={[]}>
      <PageHeader title="Portfolio" />
      {data ? (
        <View style={styles.body}>
          <ScrollView
            contentContainerStyle={styles.scroll}
            refreshControl={
              <RefreshControl
                refreshing={portfolio.isRefetching}
                onRefresh={() => portfolio.refetch()}
                colors={[userHomeColors.emptyGrey]}
                tintColor={userHomeColors.emptyGrey}
              />
            }
          >
            <Card style={styles.summary}>
              <Text style={styles.rentRollLabel}>Rent roll this month</Text>
              <Text style={styles.rentRollValue}>{formatRinggit(data.rent_roll)}</Text>
              <Text style={styles.tenantCount}>{data.tenant_count} tenants</Text>
            </Card>
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
        </View>
      ) : portfolio.isError ? (
        <ErrorState onRetry={() => portfolio.refetch()} />
      ) : (
        <LoadingState />
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scroll: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
  },
  summary: {
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  rentRollLabel: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
  },
  rentRollValue: {
    ...textStyles.displayLarge,
    color: userHomeColors.navy,
    marginTop: spacing.xs,
  },
  tenantCount: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: spacing.xs,
  },
  empty: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xl,
  },
  tenantRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  avatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
  },
  avatarFallback: {
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: userHomeColors.navy,
  },
  tenantBody: {
    flex: 1,
  },
  tenantName: {
    ...textStyles.body,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  tenantAddress: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
});
