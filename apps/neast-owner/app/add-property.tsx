import { useState } from 'react';
import { Image, Modal, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import {
  Button,
  PageHeader,
  spacing,
  TextField,
  textStyles,
  Toast,
  UploadProgressDialog,
  userHomeColors,
} from '@neast/ui-mobile';

import photoUpload from '@assets/images/property/photo-upload.png';
import successImage from '@assets/images/property/success.png';

import { apiErrorMessage } from '@/lib/api';
import { createProperty } from '@/lib/endpoints';
import { pickImageFile } from '@/lib/pickers';
import { useFileUpload } from '@/hooks/use-upload';
import { Screen } from '@/components/Screen';

interface UploadedFile {
  path: string;
  label: string;
  /** Local uri for image preview. */
  uri?: string;
}

/** Add property: name, address, and photo. A bank account is required before the QR. */
export default function AddPropertyRoute() {
  const queryClient = useQueryClient();
  const [name, setName] = useState('');
  const [address, setAddress] = useState('');
  const [photo, setPhoto] = useState<UploadedFile | null>(null);
  const [successVisible, setSuccessVisible] = useState(false);
  const uploader = useFileUpload();

  const createMutation = useMutation({
    mutationFn: () =>
      createProperty({
        name: name.trim(),
        address: address.trim(),
        image: photo!.path,
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['property-list'] });
      setSuccessVisible(true);
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const pickPhoto = async () => {
    const file = await pickImageFile();
    if (!file) return;
    const path = await uploader.upload(file);
    if (path) setPhoto({ path, label: file.name, uri: file.uri });
  };

  const ready = name.trim() !== '' && address.trim() !== '' && photo !== null;

  return (
    <Screen edges={[]}>
      <PageHeader title="Add Property" />
      <View style={styles.body}>
        <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
          <TextField label="Property name" value={name} onChangeText={setName} />
          <TextField
            label="Address"
            value={address}
            onChangeText={setAddress}
            multiline
            containerStyle={styles.addressField}
          />

          <Text style={styles.sectionLabel}>Property photo</Text>
          <Pressable onPress={pickPhoto} accessibilityRole="button" style={styles.uploadTile}>
            <Image
              source={photo?.uri ? { uri: photo.uri } : photoUpload}
              style={photo?.uri ? styles.uploadPreview : styles.uploadPlaceholder}
              resizeMode="cover"
            />
            <Text style={styles.uploadText}>{photo ? photo.label : 'Tap to upload a photo'}</Text>
          </Pressable>

          <Button
            title="Create Property"
            onPress={() => createMutation.mutate()}
            disabled={!ready}
            loading={createMutation.isPending}
            style={styles.submit}
          />
        </ScrollView>
      </View>

      {uploader.progress !== null ? (
        <UploadProgressDialog
          visible
          progress={uploader.progress}
          fileName={uploader.fileName}
          onCancel={uploader.cancel}
        />
      ) : null}

      <Modal visible={successVisible} transparent animationType="fade">
        <View style={styles.successOverlay}>
          <View style={styles.successDialog}>
            <Image source={successImage} style={styles.successImage} resizeMode="contain" />
            <Text style={styles.successTitle}>Property created</Text>
            <Text style={styles.successMessage}>
              Your property is live. Share its QR code with your tenant to connect.
            </Text>
            <Button
              title="Done"
              onPress={() => {
                setSuccessVisible(false);
                router.back();
              }}
            />
          </View>
        </View>
      </Modal>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
  },
  addressField: {
    marginTop: 0,
  },
  sectionLabel: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    color: userHomeColors.textPrimary,
    marginTop: spacing.xs,
  },
  uploadTile: {
    borderWidth: 1,
    borderColor: userHomeColors.border,
    borderStyle: 'dashed',
    borderRadius: 12,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    padding: spacing.lg,
    gap: spacing.sm,
  },
  uploadPlaceholder: {
    width: 48,
    height: 48,
  },
  uploadPreview: {
    width: '100%',
    height: 160,
    borderRadius: 8,
  },
  uploadText: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
  },
  submit: {
    marginTop: spacing.md,
  },
  successOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  successDialog: {
    backgroundColor: userHomeColors.surface,
    borderRadius: 16,
    padding: spacing.xl,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  successImage: {
    width: 96,
    height: 96,
  },
  successTitle: {
    ...textStyles.heading3,
    color: userHomeColors.navy,
    marginTop: spacing.md,
  },
  successMessage: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xs,
    marginBottom: spacing.lg,
  },
});
