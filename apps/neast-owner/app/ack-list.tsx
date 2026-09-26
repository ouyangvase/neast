import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import type { LandlordAckItem } from '@neast/types';
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

import { getAckList } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState, ListSkeleton } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Ack list (ack_list_screen parity): settled payments awaiting receipt confirmation. */
export default function AckListRoute() {
  const theme = useUiTheme();
  const setAckItem = useSelectionStore((state) => state.setAckItem);
  const list = useQuery({ queryKey: ['ack-list'], queryFn: getAckList });

  return (
    <Screen edges={[]}>
      <GradientHeader
        colors={theme.gradients.header}
        title="Confirm Receipts"
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
          emptyTitle="Nothing to confirm"
          emptyMessage="Settled tenant payments will appear here."
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <AckRow
              item={item}
              onPress={() => {
                setAckItem(item);
                router.push('/ack-detail');
              }}
            />
          )}
        />
      )}
    </Screen>
  );
}

function AckRow({ item, onPress }: { item: LandlordAckItem; onPress: () => void }) {
  return (
    <Card style={styles.row} onPress={onPress}>
      <View style={styles.avatar}>
        <Text style={styles.avatarText}>{item.initials}</Text>
      </View>
      <View style={styles.rowBody}>
        <Text style={styles.rowName} numberOfLines={1}>
          {item.name}
        </Text>
        <Text style={styles.rowMeta} numberOfLines={1}>
          {item.property_name || item.property_address}
        </Text>
        <Text style={styles.rowDate}>{item.paid_text}</Text>
      </View>
      <Text style={styles.rowAmount}>RM{item.amount}</Text>
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
    color: coreColors.darkGreen,
    marginTop: 2,
  },
  rowAmount: {
    ...textStyles.body,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
});
