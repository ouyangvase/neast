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
  Card,
  coreColors,
  ownerAccentColors,
  SectionHeader,
  spacing,
  textStyles,
} from '@neast/ui-mobile';

import headerBg from '../../../assets/images/home/header-bg.png';
import msgIcon from '../../../assets/images/home/msg-icon.png';
import addPropertyIcon from '../../../assets/images/home/quick_actions/add_property.png';

import { getHomeDashboard } from '../../lib/endpoints';
import { useSelectionStore } from '../../stores/selection';
import { ErrorState, LoadingState } from '../../components/StateViews';
import { useAddPropertyGate } from '../properties/AddPropertyGate';

/** Home tab (home_screen parity): dashboard header, need-action, portfolio, quick actions. */
export function HomeTab() {
  const insets = useSafeAreaInsets();
  const dashboard = useQuery({ queryKey: ['home-dashboard'], queryFn: getHomeDashboard });
  const setDueItem = useSelectionStore((state) => state.setDueItem);
  const setAckItem = useSelectionStore((state) => state.setAckItem);
  const setBindRequest = useSelectionStore((state) => state.setBindRequest);
  const addProperty = useAddPropertyGate();

  const data = dashboard.data;

  const openDueItem = (item: LandlordDueItem) => {
    setDueItem(item);
    router.push('/rent-detail');
  };

  return (
    <View style={styles.container}>
      <ImageBackground
        source={headerBg}
        style={[styles.header, { paddingTop: insets.top + spacing.md }]}
        resizeMode="cover"
      >
        <View style={styles.headerTopRow}>
          <Text style={styles.headerTitle}>NEAST Owner</Text>
          <Pressable
            onPress={() => router.push('/notification')}
            accessibilityRole="button"
            accessibilityLabel="Notifications"
            hitSlop={12}
          >
            <Image source={msgIcon} style={styles.bellIcon} />
            {data?.has_unread_message ? <View style={styles.unreadDot} /> : null}
          </Pressable>
        </View>
        <Text style={styles.collectedLabel}>Collected this month</Text>
        <Text style={styles.collectedAmount}>{formatRinggit(data?.header.collected ?? 0)}</Text>
        <View style={styles.statRow}>
          <View style={styles.statCell}>
            <Text style={styles.statValue}>{data?.header.collection_rate ?? 0}%</Text>
            <Text style={styles.statLabel}>Collection rate</Text>
          </View>
          <View style={styles.statDivider} />
          <View style={styles.statCell}>
            <Text style={[styles.statValue, styles.overdueValue]}>
              {formatRinggit(data?.header.overdue_amount ?? 0)}
            </Text>
            <Text style={styles.statLabel}>Overdue</Text>
          </View>
        </View>
      </ImageBackground>

      {dashboard.isLoading ? (
        <LoadingState />
      ) : dashboard.isError || !data ? (
        <ErrorState onRetry={() => dashboard.refetch()} />
      ) : (
        <ScrollView
          contentContainerStyle={styles.scroll}
          refreshControl={
            <RefreshControl
              refreshing={dashboard.isRefetching}
              onRefresh={() => dashboard.refetch()}
              colors={[coreColors.actionGreen]}
              tintColor={coreColors.actionGreen}
            />
          }
        >
          <View style={styles.actionGrid}>
            <ActionCard label="Overdue" count={data.need_action.overdue} />
            <ActionCard label="Due soon" count={data.need_action.due_soon} />
            <ActionCard
              label="To confirm"
              count={data.need_action.need_ack}
              onPress={() => router.push('/ack-list')}
            />
            <ActionCard
              label="Bind requests"
              count={data.need_action.bind_req}
              onPress={() => router.push('/bind-request-list')}
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

          {data.bind_request ? (
            <Card
              style={styles.itemCard}
              onPress={() => {
                setBindRequest(data.bind_request);
                router.push('/bind-request-detail');
              }}
            >
              <View style={styles.itemHeaderRow}>
                <Text style={styles.itemTitle}>Bind request</Text>
                <Text style={styles.itemAmount}>RM{data.bind_request.rent}</Text>
              </View>
              <Text style={styles.itemSubtitle}>
                {data.bind_request.user_name} · {data.bind_request.payday}
              </Text>
              <Text style={styles.itemMeta} numberOfLines={1}>
                {data.bind_request.property_name || data.bind_request.property_address}
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
                <Text style={styles.portfolioValue}>{formatRinggit(data.portfolio.rent_roll)}</Text>
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
        </ScrollView>
      )}
      {addProperty.dialog}
    </View>
  );
}

function ActionCard({
  label,
  count,
  onPress,
}: {
  label: string;
  count: number;
  onPress?: () => void;
}) {
  return (
    <Card style={styles.actionCard} onPress={onPress}>
      <Text style={[styles.actionCount, count > 0 && styles.actionCountActive]}>{count}</Text>
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
    backgroundColor: coreColors.white,
  },
  header: {
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.lg,
  },
  headerTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  headerTitle: {
    ...textStyles.heading3,
    color: coreColors.brandBlue,
  },
  bellIcon: {
    width: 24,
    height: 24,
  },
  unreadDot: {
    position: 'absolute',
    top: 0,
    right: 0,
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.error,
  },
  collectedLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.lg,
  },
  collectedAmount: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: spacing.xs,
  },
  statRow: {
    flexDirection: 'row',
    marginTop: spacing.lg,
    backgroundColor: 'rgba(255, 255, 255, 0.7)',
    borderRadius: 12,
    paddingVertical: spacing.md,
  },
  statCell: {
    flex: 1,
    alignItems: 'center',
  },
  statDivider: {
    width: StyleSheet.hairlineWidth,
    backgroundColor: coreColors.border,
  },
  statValue: {
    ...textStyles.heading2,
    color: coreColors.brandBlue,
  },
  overdueValue: {
    color: ownerAccentColors.orange,
  },
  statLabel: {
    ...textStyles.caption,
    marginTop: 2,
  },
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
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
  },
  actionCount: {
    ...textStyles.heading1,
    color: coreColors.textHint,
  },
  actionCountActive: {
    color: ownerAccentColors.orange,
  },
  actionLabel: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
  itemCard: {
    gap: spacing.xs,
  },
  itemHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  itemTitle: {
    ...textStyles.heading3,
  },
  itemAmount: {
    ...textStyles.heading3,
    color: coreColors.brandBlue,
  },
  itemSubtitle: {
    ...textStyles.bodySmall,
  },
  itemMeta: {
    ...textStyles.caption,
  },
  dueRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    marginBottom: spacing.sm,
  },
  dueAvatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: ownerAccentColors.surfaceBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dueAvatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: coreColors.brandBlue,
  },
  dueBody: {
    flex: 1,
  },
  dueName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
  },
  dueMeta: {
    ...textStyles.caption,
    marginTop: 2,
  },
  dueRight: {
    alignItems: 'flex-end',
  },
  dueAmount: {
    ...textStyles.bodySmall,
    fontWeight: '700',
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
    color: ownerAccentColors.orange,
  },
  portfolioCard: {
    backgroundColor: ownerAccentColors.gradientWarmStart,
  },
  portfolioTitle: {
    ...textStyles.heading3,
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
    color: ownerAccentColors.orange,
  },
  portfolioLabel: {
    ...textStyles.caption,
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
    textAlign: 'center',
    marginTop: spacing.xs,
  },
});
