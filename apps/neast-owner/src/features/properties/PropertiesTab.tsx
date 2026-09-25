import { useState } from 'react';
import { Image, Modal, Pressable, StyleSheet, Text, View } from 'react-native';

import type { LandlordProperty } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  QrCodeView,
  RefreshList,
  spacing,
  textStyles,
} from '@neast/ui-mobile';

import housePlaceholder from '../../../assets/images/house-eg.png';

import { Screen } from '../../components/Screen';
import { getPropertyList } from '../../lib/endpoints';
import { usePaginatedList } from '../../hooks/use-paginated';
import { ListSkeleton } from '../../components/StateViews';
import { useAddPropertyGate } from './AddPropertyGate';

/** Properties tab (properties_screen parity): paginated list + per-property QR dialog. */
export function PropertiesTab() {
  const list = usePaginatedList<LandlordProperty>(['property-list'], (page, limit) =>
    getPropertyList(page, limit),
  );
  const [qrProperty, setQrProperty] = useState<LandlordProperty | null>(null);
  const addProperty = useAddPropertyGate();

  return (
    <Screen>
      <View style={styles.container}>
      <View style={styles.titleRow}>
        <Text style={styles.title}>Properties</Text>
        <Button
          title="Add Property"
          size="small"
          fullWidth={false}
          onPress={addProperty.checkAndGo}
        />
      </View>

      {list.isLoading ? (
        <ListSkeleton rows={4} />
      ) : (
        <RefreshList
          data={list.items}
          keyExtractor={(item) => String(item.id)}
          refreshing={list.refreshing}
          onRefresh={list.refresh}
          onLoadMore={list.loadMore}
          hasMore={list.hasMore}
          loadingMore={list.loadingMore}
          emptyTitle="No properties yet"
          emptyMessage="Add your first property to start binding tenants."
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <PropertyRow property={item} onShowQr={() => setQrProperty(item)} />
          )}
        />
      )}

      <Modal
        visible={qrProperty !== null}
        transparent
        animationType="fade"
        onRequestClose={() => setQrProperty(null)}
      >
        <View style={styles.qrOverlay}>
          <View style={styles.qrDialog}>
            <Text style={styles.qrTitle} numberOfLines={1}>
              {qrProperty?.name}
            </Text>
            <Text style={styles.qrSubtitle}>
              Have your tenant scan this code to connect with this property.
            </Text>
            <QrCodeView value={qrProperty?.sn ?? ''} size={200} style={styles.qr} />
            <Text style={styles.qrSn}>{qrProperty?.sn}</Text>
            <Button title="Close" variant="ghost" onPress={() => setQrProperty(null)} />
          </View>
        </View>
      </Modal>
      {addProperty.dialog}
      </View>
    </Screen>
  );
}

function PropertyRow({
  property,
  onShowQr,
}: {
  property: LandlordProperty;
  onShowQr: () => void;
}) {
  return (
    <Card style={styles.row}>
      <Image
        source={property.image ? { uri: property.image } : housePlaceholder}
        style={styles.thumb}
        resizeMode="cover"
      />
      <View style={styles.rowBody}>
        <Text style={styles.rowName} numberOfLines={1}>
          {property.name}
        </Text>
        <Text style={styles.rowAddress} numberOfLines={2}>
          {property.address}
        </Text>
      </View>
      <Pressable
        onPress={onShowQr}
        accessibilityRole="button"
        accessibilityLabel="Show property QR code"
        hitSlop={8}
        style={styles.qrButton}
      >
        <Text style={styles.qrButtonText}>QR</Text>
      </Pressable>
    </Card>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.md,
  },
  title: {
    ...textStyles.heading1,
  },
  listContent: {
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  thumb: {
    width: 64,
    height: 64,
    borderRadius: 8,
    backgroundColor: coreColors.appBarBackground,
  },
  rowBody: {
    flex: 1,
  },
  rowName: {
    ...textStyles.body,
    fontWeight: '600',
  },
  rowAddress: {
    ...textStyles.caption,
    marginTop: 2,
  },
  qrButton: {
    borderWidth: 1,
    borderColor: coreColors.brandBlue,
    borderRadius: 8,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },
  qrButtonText: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  qrOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  qrDialog: {
    backgroundColor: coreColors.white,
    borderRadius: 12,
    padding: spacing.xl,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  qrTitle: {
    ...textStyles.heading3,
  },
  qrSubtitle: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: spacing.xs,
  },
  qr: {
    marginTop: spacing.lg,
  },
  qrSn: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.md,
    marginBottom: spacing.md,
  },
});
