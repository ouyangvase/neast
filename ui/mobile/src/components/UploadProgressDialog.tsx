import { Modal, StyleSheet, Text, View } from 'react-native';

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Button } from './Button';

export interface UploadProgressDialogProps {
  visible: boolean;
  /** 0–1 upload progress (drive it from your upload service's progress callback). */
  progress: number;
  fileName?: string;
  title?: string;
  /** When set, a cancel button is shown (wire to your upload cancel token). */
  onCancel?: () => void;
}

/** Modal progress bar for the chunked upload flow (upload_progress_dialog equivalent). */
export function UploadProgressDialog({
  visible,
  progress,
  fileName,
  title = 'Uploading…',
  onCancel,
}: UploadProgressDialogProps) {
  const clamped = Math.min(1, Math.max(0, progress));
  const percent = Math.round(clamped * 100);
  return (
    <Modal visible={visible} transparent animationType="fade">
      <View style={styles.overlay}>
        <View style={styles.dialog}>
          <Text style={styles.title}>{title}</Text>
          {fileName ? (
            <Text style={styles.fileName} numberOfLines={1}>
              {fileName}
            </Text>
          ) : null}
          <View style={styles.track}>
            <View style={[styles.fill, { width: `${percent}%` }]} />
          </View>
          <Text style={styles.percent}>{percent}%</Text>
          {onCancel ? (
            <Button
              title="Cancel"
              variant="ghost"
              onPress={onCancel}
              fullWidth={false}
              style={styles.cancel}
            />
          ) : null}
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  dialog: {
    backgroundColor: coreColors.white,
    borderRadius: radii.card,
    padding: spacing.xl,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  title: {
    ...textStyles.heading3,
  },
  fileName: {
    ...textStyles.caption,
    marginTop: spacing.xs,
    alignSelf: 'stretch',
    textAlign: 'center',
  },
  track: {
    alignSelf: 'stretch',
    height: 8,
    borderRadius: radii.pill,
    backgroundColor: coreColors.divider,
    marginTop: spacing.lg,
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    borderRadius: radii.pill,
    backgroundColor: coreColors.actionGreen,
  },
  percent: {
    ...textStyles.bodySmall,
    fontWeight: '600',
    marginTop: spacing.sm,
  },
  cancel: {
    marginTop: spacing.md,
  },
});
