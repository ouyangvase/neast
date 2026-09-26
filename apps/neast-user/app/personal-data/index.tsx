import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { Card, Chevron, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { useUserProfile } from '@/hooks/use-profile';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

/** Personal data (personal_data_screen parity): read-only profile field list. */
export default function PersonalDataRoute() {
  const profile = useUserProfile();

  if (profile.isLoading) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Personal Information" />
        <LoadingState />
      </Screen>
    );
  }

  const user = profile.data;
  if (!user) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Personal Information" />
        <ErrorState onRetry={() => profile.refetch()} />
      </Screen>
    );
  }

  const rows: { label: string; value: string; field?: string }[] = [
    { label: 'First name', value: user.firstName || '-', field: 'first_name' },
    { label: 'Last name', value: user.lastName || '-', field: 'last_name' },
    { label: 'Email', value: user.email ?? '-', field: 'email' },
    { label: 'Phone', value: user.account ? `+${user.account}` : '-' },
    { label: 'Address', value: user.address ?? '-', field: 'address' },
    { label: 'ID valid until', value: user.idValidUntil ?? '-', field: 'id_valid_until' },
  ];

  return (
    <Screen edges={[]}>
      <PageHeader title="Personal Information" />
      <ScrollView contentContainerStyle={styles.scroll}>
        <Card style={styles.card}>
          {rows.map((row, index) => (
            <Pressable
              key={row.label}
              style={[styles.row, index > 0 && styles.rowBorder]}
              disabled={!row.field}
              onPress={() =>
                row.field
                  ? router.push({
                      pathname: '/personal-data/edit',
                      params: { field: row.field, label: row.label, value: row.value },
                    })
                  : undefined
              }
              accessibilityRole={row.field ? 'button' : undefined}
            >
              <Text style={styles.rowLabel}>{row.label}</Text>
              <View style={styles.rowRight}>
                <Text style={styles.rowValue} numberOfLines={1}>
                  {row.value}
                </Text>
                {row.field ? <Chevron /> : null}
              </View>
            </Pressable>
          ))}
        </Card>
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
  },
  card: {
    paddingVertical: spacing.xs,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.xs,
    gap: spacing.md,
  },
  rowBorder: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: coreColors.divider,
  },
  rowLabel: {
    ...textStyles.body,
  },
  rowRight: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    flexShrink: 1,
  },
  rowValue: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    flexShrink: 1,
  },
});
