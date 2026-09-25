import { useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useFocusEffect } from 'expo-router';
import * as Notifications from 'expo-notifications';
import { useQueryClient } from '@tanstack/react-query';

import { formatRelativeTime, type MessageItem } from '@neast/types';
import { coreColors, RefreshList, spacing, textStyles } from '@neast/ui-mobile';

import { getMessages, markAllMessagesRead } from '../src/lib/endpoints';
import { usePaginatedList } from '../src/hooks/use-paginated';
import { PageHeader } from '../src/components/PageHeader';
import { Screen } from '../src/components/Screen';

/**
 * Notification list (notification_screen parity). On open: clears the app
 * badge, marks all read, then refreshes unread state + the list.
 */
export default function NotificationRoute() {
  const queryClient = useQueryClient();
  const list = usePaginatedList(['messages'], (page, limit) => getMessages(page, limit), 15);

  useFocusEffect(
    useCallback(() => {
      void Notifications.setBadgeCountAsync(0);
      void markAllMessagesRead()
        .catch(() => {
          // best-effort — the list still renders
        })
        .then(() => {
          void queryClient.invalidateQueries({ queryKey: ['has-unread'] });
          void queryClient.invalidateQueries({ queryKey: ['messages'] });
        });
    }, [queryClient]),
  );

  return (
    <Screen edges={[]}>
      <PageHeader title="Notifications" />
      <RefreshList
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No notifications"
        emptyMessage="You're all caught up."
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => <NotificationRow item={item} />}
      />
    </Screen>
  );
}

function NotificationRow({ item }: { item: MessageItem }) {
  const unread = item.is_read === 0;
  return (
    <View style={styles.row}>
      <View style={styles.rowHeader}>
        <Text style={styles.rowTitle} numberOfLines={1}>
          {item.title}
        </Text>
        {unread ? <View style={styles.dot} /> : null}
      </View>
      <Text style={styles.rowContent}>{item.content}</Text>
      <Text style={styles.rowTime}>{formatRelativeTime(item.created_at)}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  row: {
    backgroundColor: coreColors.tintBlue,
    borderRadius: 12,
    padding: spacing.md,
  },
  rowHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  rowTitle: {
    ...textStyles.body,
    fontWeight: '600',
    flex: 1,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.error,
  },
  rowContent: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.xs,
  },
  rowTime: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
});
