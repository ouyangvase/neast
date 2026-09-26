import {
  Image,
  ImageBackground,
  Pressable,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { formatRinggit, type LandlordDueItem } from '@neast/types';
import {
  BellIcon,
  Card,
  coreColors,
  SectionHeader,
  spacing,
  textStyles,
  userHomeColors,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';
import addPropertyIcon from '@assets/images/home/quick_actions/add_property.png';

import { getHomeDashboard } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { useAddPropertyGate } from '@/features/properties/AddPropertyGate';

type ActionTone = 'overdue' | 'soon' | 'confirm';

/** Home tab: dashboard header, need-action, portfolio, and add property. */
export function HomeTab() {
  const insets = useSafeAreaInsets();
  const dashboard = useQuery({ queryKey: ['home-dashboard'], queryFn: getHomeDashboard });
  const setDueItem = useSelectionStore((state) => state.setDueItem);
  const setAckItem = useSelectionStore((state) => state.setAckItem);
  const addProperty = useAddPropertyGate();

  const data = dashboard.data;

  const openDueItem = (item: LandlordDueItem) => {
    setDueItem(item);
    router.push('/rent-detail');
  };

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        refreshControl={
          <RefreshControl
            refreshing={dashboard.isRefetching}
            onRefresh={() => dashboard.refetch()}
            colors={[userHomeColors.emptyGrey]}
            tintColor={userHomeColors.emptyGrey}
          />
        }
      >
        <ImageBackground
          source={metallicBackground}
          resizeMode="cover"
          style={[styles.header, { paddingTop: insets.top + 8 }]}
        >
          <View style={styles.headerTopRow}>
            <Text style={styles.headerTitle}>NEAST Owner</Text>
            <Pressable
              onPress={() => router.push('/notification')}
              accessibilityRole="button"
              accessibilityLabel="Notifications"
              hitSlop={12}
            >
              <BellIcon size={32} />
              {data?.has_unread_message ? <View style={styles.unreadDot} /> : null}
            </Pressable>
          </View>
          <Text style={styles.collectedLabel}>Collected this month</Text>
          {data ? (
            <>
              <Text style={styles.collectedAmount}>{formatRinggit(data.header.collected)}</Text>
              <View style={styles.statRow}>
                <View style={styles.statCell}>
                  <Text style={styles.statValue}>{data.header.collection_rate}%</Text>
                  <Text style={styles.statLabel}>Collection rate</Text>
                </View>
                <View style={styles.statDivider} />
                <View style={styles.statCell}>
                  <Text style={[styles.statValue, styles.overdueValue]}>
                    {formatRinggit(data.header.overdue_amount)}
                  </Text>
                  <Text style={styles.statLabel}>Overdue</Text>
                </View>
              </View>
            </>
          ) : null}
        </ImageBackground>

        {data ? (
          <View style={styles.sheet}>
            <View style={styles.actionGrid}>
              <ActionCard label="Overdue" count={data.need_action.overdue} tone="overdue" />
              <ActionCard label="Due soon" count={data.need_action.due_soon} tone="soon" />
              <ActionCard
                label="To confirm"
                count={data.need_action.need_ack}
                tone="confirm"
                onPress={() => router.push('/ack-list')}
              />
            </View>

            {data.need_ack ? (
              <Card
                style={styles.itemCard}
                onPress={() => {
                  setAckItem(data.need_ack);
                  router.push('/ack-detail');
                }}
              >
                <View style={styles.itemHeaderRow}>
                  <Text style={styles.itemTitle}>Confirm receipt</Text>
                  <Text style={styles.itemAmount}>RM{data.need_ack.amount}</Text>
                </View>
                <Text style={styles.itemSubtitle}>
                  {data.need_ack.name} · {data.need_ack.paid_text}
                </Text>
                <Text style={styles.itemMeta} numberOfLines={1}>
                  {data.need_ack.property_name || data.need_ack.property_address}
                </Text>
              </Card>
            ) : null}

            {data.overdue_list.length > 0 ? (
              <View>
                <SectionHeader title="Overdue" />
                {data.overdue_list.map((item) => (
                  <DueRow key={item.id} item={item} onPress={() => openDueItem(item)} />
                ))}
              </View>
            ) : null}

            {data.due_soon_list.length > 0 ? (
              <View>
                <SectionHeader title="Due soon" />
                {data.due_soon_list.map((item) => (
                  <DueRow key={item.id} item={item} onPress={() => openDueItem(item)} />
                ))}
              </View>
            ) : null}

            <Card style={styles.portfolioCard} onPress={() => router.push('/portfolio-snapshot')}>
              <Text style={styles.portfolioTitle}>Portfolio snapshot</Text>
              <View style={styles.portfolioRow}>
                <View style={styles.portfolioCell}>
                  <Text style={styles.portfolioValue}>{data.portfolio.properties}</Text>
                  <Text style={styles.portfolioLabel}>Properties</Text>
                </View>
                <View style={styles.portfolioCell}>
                  <Text style={styles.portfolioValue}>{data.portfolio.tenants}</Text>
                  <Text style={styles.portfolioLabel}>Tenants</Text>
                </View>
                <View style={styles.portfolioCell}>
                  <Text style={styles.portfolioValue}>
                    {formatRinggit(data.portfolio.rent_roll)}
                  </Text>
                  <Text style={styles.portfolioLabel}>Rent roll</Text>
                </View>
              </View>
            </Card>

            <View>
              <SectionHeader title="Quick actions" />
              <View style={styles.quickRow}>
                <Pressable
                  style={styles.quickAction}
                  onPress={addProperty.checkAndGo}
                  accessibilityRole="button"
                >
                  <Image source={addPropertyIcon} style={styles.quickIcon} />
                  <Text style={styles.quickLabel}>Add Property</Text>
                </Pressable>
              </View>
            </View>
          </View>
        ) : dashboard.isError ? (
          <ErrorState onRetry={() => dashboard.refetch()} />
        ) : (
          <LoadingState />
        )}
      </ScrollView>
      {addProperty.dialog}
    </View>
  );
}

function ActionCard({
  label,
  count,
  tone,
  onPress,
}: {
  label: string;
  count: number;
  tone: ActionTone;
  onPress?: () => void;
}) {
  const activeColor =
    tone === 'overdue'
      ? coreColors.error
      : tone === 'soon'
        ? userHomeColors.gold
        : userHomeColors.navy;
  return (
    <Card style={styles.actionCard} onPress={onPress}>
      <Text style={[styles.actionCount, count > 0 && { color: activeColor }]}>{count}</Text>
      <Text style={styles.actionLabel}>{label}</Text>
    </Card>
  );
}

function DueRow({ item, onPress }: { item: LandlordDueItem; onPress: () => void }) {
  const overdue = item.status === 'overdue';
  return (
    <Card style={styles.dueRow} onPress={onPress}>
      <View style={styles.dueAvatar}>
        <Text style={styles.dueAvatarText}>{item.tenant_initials}</Text>
      </View>
      <View style={styles.dueBody}>
        <Text style={styles.dueName} numberOfLines={1}>
          {item.tenant_name}
        </Text>
        <Text style={styles.dueMeta} numberOfLines={1}>
          {item.unit_address}
        </Text>
      </View>
      <View style={styles.dueRight}>
        <Text style={styles.dueAmount}>RM{item.amount}</Text>
        <Text style={[styles.dueStatus, overdue ? styles.statusOverdue : styles.statusDueSoon]}>
          {item.status_text}
        </Text>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scrollContent: {
    flexGrow: 1,
  },
  header: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 20,
    paddingBottom: 36,
  },
  headerTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  headerTitle: {
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  unreadDot: {
    position: 'absolute',
    top: 2,
    right: 2,
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: userHomeColors.badgeRed,
  },
  collectedLabel: {
    ...textStyles.bodySmall,
    color: userHomeColors.textOnNavyAlt,
    marginTop: spacing.lg,
  },
  collectedAmount: {
    ...textStyles.displayLarge,
    color: userHomeColors.surface,
    marginTop: spacing.xs,
  },
  statRow: {
    flexDirection: 'row',
    marginTop: spacing.lg,
  },
  statCell: {
    flex: 1,
    alignItems: 'center',
  },
  statDivider: {
    width: StyleSheet.hairlineWidth,
    backgroundColor: userHomeColors.textOnNavyMuted,
  },
  statValue: {
    ...textStyles.heading2,
    color: userHomeColors.surface,
  },
  overdueValue: {
    color: coreColors.error,
  },
  statLabel: {
    ...textStyles.caption,
    color: userHomeColors.textOnNavyMuted,
    marginTop: 2,
  },
  sheet: {
    marginTop: -20,
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
    backgroundColor: userHomeColors.background,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  actionGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.md,
  },
  actionCard: {
    flexBasis: '47%',
    flexGrow: 1,
    alignItems: 'center',
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  actionCount: {
    ...textStyles.heading1,
    color: userHomeColors.emptyGrey,
  },
  actionLabel: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: spacing.xs,
  },
  itemCard: {
    gap: spacing.xs,
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  itemHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  itemTitle: {
    ...textStyles.heading3,
    color: userHomeColors.textPrimary,
  },
  itemAmount: {
    ...textStyles.heading3,
    color: userHomeColors.navy,
  },
  itemSubtitle: {
    ...textStyles.bodySmall,
    color: userHomeColors.textPrimary,
  },
  itemMeta: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
  },
  dueRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    marginBottom: spacing.sm,
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  dueAvatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dueAvatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: userHomeColors.navy,
  },
  dueBody: {
    flex: 1,
  },
  dueName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  dueMeta: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
  dueRight: {
    alignItems: 'flex-end',
  },
  dueAmount: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: userHomeColors.textPrimary,
  },
  dueStatus: {
    ...textStyles.caption,
    marginTop: 2,
    fontWeight: '600',
  },
  statusOverdue: {
    color: coreColors.error,
  },
  statusDueSoon: {
    color: userHomeColors.gold,
  },
  portfolioCard: {
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  portfolioTitle: {
    ...textStyles.heading3,
    color: userHomeColors.textPrimary,
  },
  portfolioRow: {
    flexDirection: 'row',
    marginTop: spacing.md,
  },
  portfolioCell: {
    flex: 1,
    alignItems: 'center',
  },
  portfolioValue: {
    ...textStyles.body,
    fontWeight: '700',
    color: userHomeColors.navy,
  },
  portfolioLabel: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
  quickRow: {
    flexDirection: 'row',
    gap: spacing.md,
  },
  quickAction: {
    alignItems: 'center',
    width: 72,
  },
  quickIcon: {
    width: 48,
    height: 48,
  },
  quickLabel: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xs,
  },
});
