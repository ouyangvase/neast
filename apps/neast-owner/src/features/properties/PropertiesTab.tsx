import { useState } from 'react';
import { Image, ImageBackground, Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import type { LandlordProperty } from '@neast/types';
import {
  Button,
  Card,
  QrCodeView,
  RefreshList,
  spacing,
  textStyles,
  userHomeColors,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';
import housePlaceholder from '@assets/images/house-eg.png';

import { getPropertyList } from '@/lib/endpoints';
import { usePaginatedList } from '@/hooks/use-paginated';
import { ListSkeleton } from '@/components/StateViews';
import { useAddPropertyGate } from './AddPropertyGate';

/** Properties tab: paginated list and a per-property QR dialog. */
export function PropertiesTab() {
  const insets = useSafeAreaInsets();
  const list = usePaginatedList<LandlordProperty>(['property-list'], (page, limit) =>
    getPropertyList(page, limit),
  );
  const [qrProperty, setQrProperty] = useState<LandlordProperty | null>(null);
  const addProperty = useAddPropertyGate();

  return (
    <View style={styles.container}>
      <ImageBackground
        source={metallicBackground}
        resizeMode="cover"
        style={[styles.backdrop, { paddingTop: insets.top + 8 }]}
      >
        <View style={styles.titleRow}>
          <Text style={styles.title}>Properties</Text>
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Add Property"
            onPress={addProperty.checkAndGo}
            style={({ pressed }) => [styles.addButton, pressed && styles.pressed]}
          >
            <Text style={styles.addButtonText}>Add Property</Text>
          </Pressable>
        </View>
      </ImageBackground>

      <View style={styles.sheet}>
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
            style={styles.list}
            renderItem={({ item }) => (
              <PropertyRow property={item} onShowQr={() => setQrProperty(item)} />
            )}
          />
        )}
      </View>

      {qrProperty ? (
        <Modal
          visible
          transparent
          animationType="fade"
          onRequestClose={() => setQrProperty(null)}
        >
          <View style={styles.qrOverlay}>
            <View style={styles.qrDialog}>
              <Text style={styles.qrTitle} numberOfLines={1}>
                {qrProperty.name}
              </Text>
              <Text style={styles.qrSubtitle}>
                Have your tenant scan this code to connect with this property.
              </Text>
              <QrCodeView value={qrProperty.sn} size={200} style={styles.qr} />
              <Text style={styles.qrSn}>{qrProperty.sn}</Text>
              <Button title="Close" variant="ghost" onPress={() => setQrProperty(null)} />
            </View>
          </View>
        </Modal>
      ) : null}
      {addProperty.dialog}
    </View>
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
    backgroundColor: userHomeColors.background,
  },
  backdrop: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 20,
    paddingBottom: 36,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  addButton: {
    borderRadius: 999,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    backgroundColor: userHomeColors.surface,
  },
  addButtonText: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
  },
  sheet: {
    flex: 1,
    marginTop: -20,
    backgroundColor: userHomeColors.background,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    overflow: 'hidden',
  },
  list: {
    flex: 1,
  },
  listContent: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.md,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
  },
  thumb: {
    width: 64,
    height: 64,
    borderRadius: 8,
    backgroundColor: userHomeColors.lightBlue,
  },
  rowBody: {
    flex: 1,
  },
  rowName: {
    ...textStyles.body,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  rowAddress: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
  qrButton: {
    borderWidth: 1,
    borderColor: userHomeColors.navy,
    borderRadius: 8,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },
  qrButtonText: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
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
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    padding: spacing.xl,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  qrTitle: {
    ...textStyles.heading3,
    color: userHomeColors.navy,
  },
  qrSubtitle: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xs,
  },
  qr: {
    marginTop: spacing.lg,
  },
  qrSn: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
    marginTop: spacing.md,
    marginBottom: spacing.md,
  },
});
