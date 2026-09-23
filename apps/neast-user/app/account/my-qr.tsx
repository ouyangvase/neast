import { useRef, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { captureRef } from 'react-native-view-shot';
import * as MediaLibrary from 'expo-media-library';

import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  QrCodeView,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { useUserProfile } from '../../src/hooks/use-profile';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { Screen } from '../../src/components/Screen';

/** My QR (my_qr_screen parity): account QR + save-to-gallery via view-shot. */
export default function MyQrRoute() {
  const profile = useUserProfile();
  const cardRef = useRef<View>(null);
  const [saving, setSaving] = useState(false);

  const user = profile.data;

  const saveToGallery = async () => {
    setSaving(true);
    try {
      const permission = await MediaLibrary.requestPermissionsAsync();
      if (!permission.granted) {
        Toast.error('Photo library permission is required to save the QR code');
        return;
      }
      if (!cardRef.current) return;
      const uri = await captureRef(cardRef, { format: 'png', quality: 1 });
      await MediaLibrary.saveToLibraryAsync(uri);
      Toast.success('QR code saved to gallery');
    } catch {
      Toast.error('Could not save the QR code');
    } finally {
      setSaving(false);
    }
  };

  return (
    <Screen>
      <BrandHeader title="My QR Code" onBack={() => router.back()} />
      {profile.isLoading ? (
        <LoadingState />
      ) : !user ? (
        <ErrorState onRetry={() => profile.refetch()} />
      ) : (
        <View style={styles.body}>
          <View ref={cardRef} collapsable={false} style={styles.capture}>
            <Card style={styles.card}>
              <Text style={styles.name}>
                {user.firstName} {user.lastName}
              </Text>
              <Text style={styles.phone}>+{user.account}</Text>
              <QrCodeView value={user.qrCode} size={220} style={styles.qr} />
              <Text style={styles.hint}>Show this code to merchants to collect points</Text>
            </Card>
          </View>
          <Button title="Save to Gallery" onPress={() => void saveToGallery()} loading={saving} />
        </View>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  capture: {
    backgroundColor: 'transparent',
  },
  card: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  name: {
    ...textStyles.heading2,
  },
  phone: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.xs,
  },
  qr: {
    marginVertical: spacing.lg,
  },
  hint: {
    ...textStyles.caption,
  },
});
