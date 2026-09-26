import { useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useFocusEffect } from 'expo-router';
import * as Notifications from 'expo-notifications';
import { useQueryClient } from '@tanstack/react-query';

import { formatRelativeTime, type MessageItem } from '@neast/types';
import { PageHeader, RefreshList, spacing, textStyles, userHomeColors } from '@neast/ui-mobile';

import { getMessages, markAllMessagesRead } from '@/lib/endpoints';
import { usePaginatedList } from '@/hooks/use-paginated';
import { Screen } from '@/components/Screen';

/**
 * Notification list. On open: clears the app badge, marks all read, then
 * refreshes the list and the home unread flag.
 */
export default function NotificationRoute() {
  const queryClient = useQueryClient();
  const list = usePaginatedList<MessageItem>(['messages'], (page, limit) =>
    getMessages(page, limit),
  );

  useFocusEffect(
    useCallback(() => {
      void Notifications.setBadgeCountAsync(0);
      void markAllMessagesRead().then(() => {
        void queryClient.invalidateQueries({ queryKey: ['messages'] });
        void queryClient.invalidateQueries({ queryKey: ['home-dashboard'] });
      });
    }, [queryClient]),
  );

  return (
    <Screen edges={[]}>
      <PageHeader title="Notifications" />
      <View style={styles.body}>
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
      </View>
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
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  row: {
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
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
    color: userHomeColors.textPrimary,
    flex: 1,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: userHomeColors.badgeRed,
  },
  rowContent: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
    marginTop: spacing.xs,
  },
  rowTime: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: spacing.xs,
  },
});
