import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import type { LandlordBindRequestItem } from '@neast/types';
import {
  Card,
  coreColors,
  GradientHeader,
  ownerAccentColors,
  RefreshList,
  spacing,
  textStyles,
  useUiTheme,
} from '@neast/ui-mobile';

import { getBindRequestList } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState, ListSkeleton } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Bind request list (bind_request_list_screen parity): pending tenant bind applications. */
export default function BindRequestListRoute() {
  const theme = useUiTheme();
  const setBindRequest = useSelectionStore((state) => state.setBindRequest);
  const list = useQuery({ queryKey: ['bind-request-list'], queryFn: getBindRequestList });

  return (
    <Screen edges={[]}>
      <GradientHeader
        colors={theme.gradients.header}
        title="Bind Requests"
        lightContent={false}
        onBack={() => router.back()}
      />
      {list.isLoading ? (
        <ListSkeleton rows={4} />
      ) : list.isError ? (
        <ErrorState onRetry={() => list.refetch()} />
      ) : (
        <RefreshList
          data={list.data?.items ?? []}
          keyExtractor={(item) => String(item.id)}
          refreshing={list.isRefetching}
          onRefresh={() => list.refetch()}
          emptyTitle="No bind requests"
          emptyMessage="Tenant bind applications will appear here."
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <BindRow
              item={item}
              onPress={() => {
                setBindRequest(item);
                router.push('/bind-request-detail');
              }}
            />
          )}
        />
      )}
    </Screen>
  );
}

function BindRow({ item, onPress }: { item: LandlordBindRequestItem; onPress: () => void }) {
  return (
    <Card style={styles.row} onPress={onPress}>
      <View style={styles.avatar}>
        <Text style={styles.avatarText}>{item.initials}</Text>
      </View>
      <View style={styles.rowBody}>
        <Text style={styles.rowName} numberOfLines={1}>
          {item.user_name}
        </Text>
        <Text style={styles.rowMeta} numberOfLines={1}>
          {item.property_name || item.property_address}
        </Text>
        <Text style={styles.rowDate}>{item.rental_date}</Text>
      </View>
      <View style={styles.rowRight}>
        <Text style={styles.rowAmount}>RM{item.rent}</Text>
        <Text style={styles.rowPayday}>{item.payday}</Text>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  avatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: ownerAccentColors.surfaceBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  rowBody: {
    flex: 1,
  },
  rowName: {
    ...textStyles.body,
    fontWeight: '600',
  },
  rowMeta: {
    ...textStyles.caption,
    marginTop: 2,
  },
  rowDate: {
    ...textStyles.caption,
    marginTop: 2,
  },
  rowRight: {
    alignItems: 'flex-end',
  },
  rowAmount: {
    ...textStyles.body,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  rowPayday: {
    ...textStyles.caption,
    marginTop: 2,
  },
});
