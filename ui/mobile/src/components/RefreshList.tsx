import {
  ActivityIndicator,
  FlatList,
  RefreshControl,
  StyleSheet,
  Text,
  View,
  type FlatListProps,
} from 'react-native';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { EmptyState } from './EmptyState';

export interface RefreshListProps<T> extends Omit<
  FlatListProps<T>,
  'refreshControl' | 'onEndReached' | 'ListEmptyComponent' | 'ListFooterComponent'
> {
  data: T[];
  /** Pull-refresh state + handler (omit both to disable pull-refresh). */
  refreshing?: boolean;
  onRefresh?: () => void;
  /** Load-more handler — fired on end-reached while `hasMore` and not already loading. */
  onLoadMore?: () => void;
  hasMore?: boolean;
  loadingMore?: boolean;
  /** Empty-list placeholder (defaults to a generic EmptyState). */
  emptyTitle?: string;
  emptyMessage?: string;
  ListEmptyComponent?: FlatListProps<T>['ListEmptyComponent'];
  ListFooterComponent?: FlatListProps<T>['ListFooterComponent'];
}

/**
 * Pull-refresh + infinite-scroll list — the RN equivalent of the apps'
 * `AppRefresher` (easy_refresh) wrapper around every paginated list.
 */
export function RefreshList<T>({
  data,
  refreshing = false,
  onRefresh,
  onLoadMore,
  hasMore = false,
  loadingMore = false,
  emptyTitle = 'Nothing here yet',
  emptyMessage,
  ListEmptyComponent,
  ListFooterComponent,
  onEndReachedThreshold = 0.3,
  ...flatListProps
}: RefreshListProps<T>) {
  const handleEndReached = () => {
    if (onLoadMore && hasMore && !loadingMore && !refreshing) onLoadMore();
  };

  const footer =
    ListFooterComponent !== undefined ? (
      ListFooterComponent
    ) : loadingMore ? (
      <View style={styles.footer}>
        <ActivityIndicator color={coreColors.actionGreen} />
      </View>
    ) : !hasMore && data.length > 0 ? (
      <View style={styles.footer}>
        <Text style={styles.footerText}>No more</Text>
      </View>
    ) : null;

  const empty =
    ListEmptyComponent !== undefined ? (
      ListEmptyComponent
    ) : (
      <EmptyState title={emptyTitle} message={emptyMessage} />
    );

  return (
    <FlatList
      data={data}
      onEndReached={handleEndReached}
      onEndReachedThreshold={onEndReachedThreshold}
      ListFooterComponent={footer}
      ListEmptyComponent={empty}
      refreshControl={
        onRefresh ? (
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            colors={[coreColors.actionGreen]}
            tintColor={coreColors.actionGreen}
          />
        ) : undefined
      }
      {...flatListProps}
    />
  );
}

const styles = StyleSheet.create({
  footer: {
    paddingVertical: spacing.lg,
    alignItems: 'center',
  },
  footerText: {
    ...textStyles.caption,
  },
});
