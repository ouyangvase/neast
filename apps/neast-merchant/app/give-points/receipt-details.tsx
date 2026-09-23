import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatThousands, useIsLoggedIn } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  EmptyState,
  ImagePreview,
  spacing,
  TextField,
  textStyles,
} from '@neast/ui-mobile';

import pointsPreviewImage from '../../assets/images/give_points/points-preview.png';

import { getReceiptCapture, openConfirmPoints } from '../../src/lib/callbacks';
import { getPointsSetting } from '../../src/lib/endpoints';
import { Screen } from '../../src/components/Screen';

/**
 * Receipt details (receipt_details_screen parity) — Step 1: receipt number,
 * amount, notes, live points preview from the points setting, retake.
 */
export default function ReceiptDetailsRoute() {
  const receipt = getReceiptCapture();
  const isLoggedIn = useIsLoggedIn();
  const [receiptNumber, setReceiptNumber] = useState('');
  const [amount, setAmount] = useState('');
  const [notes, setNotes] = useState('');
  const [previewVisible, setPreviewVisible] = useState(false);

  const pointsSetting = useQuery({
    queryKey: ['points-setting'],
    queryFn: getPointsSetting,
    enabled: isLoggedIn,
  });

  // Live points preview at the admin-set rate (apps-overview §6.2/§8.3:
  // points = RM amount × yuan_to_points). Computed from cents to avoid
  // binary floating-point drift on values like 48.60.
  const rate = pointsSetting.data?.yuan_to_points ?? 0;
  const cents = Math.round(Number(amount) * 100);
  const points = Number.isFinite(cents) && rate > 0 ? Math.floor((cents * rate) / 100) : 0;
  const amountValid = Number(amount) >= 0.01;

  if (!receipt) {
    return (
      <Screen>
        <BrandHeader title="Receipt Details" onBack={() => router.back()} />
        <EmptyState
          title="No receipt captured"
          message="Capture a receipt from the Give Points tab first."
          actionLabel="Go back"
          onAction={() => router.back()}
          style={styles.missing}
        />
      </Screen>
    );
  }

  const next = () => {
    openConfirmPoints({
      receiptPath: receipt.path,
      receiptNumber: receiptNumber.trim(),
      amount: amount.trim(),
      points,
      notes: notes.trim(),
    });
  };

  return (
    <Screen>
      <BrandHeader title="Receipt Details" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.content}>
        <Pressable onPress={() => setPreviewVisible(true)} accessibilityRole="imagebutton">
          <Image source={{ uri: receipt.uri }} style={styles.receiptImage} resizeMode="cover" />
          <Text style={styles.receiptHint}>Tap to view · {receipt.name}</Text>
        </Pressable>

        <Card style={styles.previewCard}>
          <Image source={pointsPreviewImage} style={styles.previewIcon} />
          <View style={styles.previewTexts}>
            <Text style={styles.previewLabel}>Customer earns</Text>
            <Text style={styles.previewValue}>
              {amountValid && points > 0 ? `${formatThousands(points)} points` : '—'}
            </Text>
          </View>
        </Card>

        <TextField
          label="Receipt number"
          value={receiptNumber}
          onChangeText={setReceiptNumber}
          placeholder="e.g. R-2604-1108"
          autoCapitalize="characters"
        />
        <TextField
          label="Amount (RM)"
          value={amount}
          onChangeText={setAmount}
          placeholder="0.00"
          keyboardType="decimal-pad"
        />
        <TextField
          label="Notes"
          value={notes}
          onChangeText={setNotes}
          placeholder="Optional"
          multiline
        />

        <View style={styles.actions}>
          <Button
            title="Retake"
            variant="outline"
            onPress={() => router.back()}
            style={styles.actionButton}
          />
          <Button
            title="Next"
            onPress={next}
            disabled={!amountValid || points < 1}
            style={styles.actionButton}
          />
        </View>
      </ScrollView>

      <ImagePreview
        visible={previewVisible}
        source={{ uri: receipt.uri }}
        onClose={() => setPreviewVisible(false)}
        caption={receipt.name}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  missing: {
    flexGrow: 1,
    justifyContent: 'center',
  },
  content: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  receiptImage: {
    width: '100%',
    height: 200,
    borderRadius: 12,
    backgroundColor: coreColors.tintBlue,
  },
  receiptHint: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xs,
  },
  previewCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  previewIcon: {
    width: 36,
    height: 36,
  },
  previewTexts: {
    flex: 1,
  },
  previewLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  previewValue: {
    ...textStyles.heading2,
    color: coreColors.darkGreen,
    marginTop: 2,
  },
  actions: {
    flexDirection: 'row',
    gap: spacing.md,
    marginTop: spacing.sm,
  },
  actionButton: {
    flex: 1,
  },
});
