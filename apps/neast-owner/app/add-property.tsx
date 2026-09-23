import { useState } from 'react';
import { Image, Modal, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import {
  BrandHeader,
  Button,
  coreColors,
  ownerAccentColors,
  spacing,
  TextField,
  textStyles,
  Toast,
  UploadProgressDialog,
} from '@neast/ui-mobile';

import photoUpload from '../assets/images/property/photo-upload.png';
import docUpload from '../assets/images/property/doc-upload.png';
import successImage from '../assets/images/property/success.png';

import { apiErrorMessage } from '../src/lib/api';
import { createProperty } from '../src/lib/endpoints';
import { pickDocumentFile, pickImageFile } from '../src/lib/pickers';
import { useFileUpload } from '../src/hooks/use-upload';
import { Screen } from '../src/components/Screen';

interface UploadedFile {
  path: string;
  label: string;
  /** Local uri for image preview. */
  uri?: string;
}

/** Add property (add_property_screen parity): name, address, photo + document upload, create. */
export default function AddPropertyRoute() {
  const queryClient = useQueryClient();
  const [name, setName] = useState('');
  const [address, setAddress] = useState('');
  const [photo, setPhoto] = useState<UploadedFile | null>(null);
  const [document, setDocument] = useState<UploadedFile | null>(null);
  const [successVisible, setSuccessVisible] = useState(false);
  const uploader = useFileUpload();

  const createMutation = useMutation({
    mutationFn: () =>
      createProperty({
        name: name.trim(),
        address: address.trim(),
        image: photo!.path,
        file: document!.path,
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

  const pickDocument = async () => {
    const file = await pickDocumentFile();
    if (!file) return;
    const path = await uploader.upload(file);
    if (path) setDocument({ path, label: file.name });
  };

  const ready =
    name.trim() !== '' && address.trim() !== '' && photo !== null && document !== null;

  return (
    <Screen>
      <BrandHeader title="Add Property" onBack={() => router.back()} />
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

        <Text style={styles.sectionLabel}>Document</Text>
        <Pressable onPress={pickDocument} accessibilityRole="button" style={styles.uploadTile}>
          <Image source={docUpload} style={styles.uploadPlaceholder} resizeMode="contain" />
          <Text style={styles.uploadText}>
            {document ? document.label : 'Tap to upload a document'}
          </Text>
        </Pressable>

        <Button
          title="Create Property"
          onPress={() => createMutation.mutate()}
          disabled={!ready}
          loading={createMutation.isPending}
          style={styles.submit}
        />
      </ScrollView>

      <UploadProgressDialog
        visible={uploader.progress !== null}
        progress={uploader.progress ?? 0}
        fileName={uploader.fileName}
        onCancel={uploader.cancel}
      />

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
    marginTop: spacing.xs,
  },
  uploadTile: {
    borderWidth: 1,
    borderColor: coreColors.border,
    borderStyle: 'dashed',
    borderRadius: 12,
    backgroundColor: ownerAccentColors.surfaceBlueLight,
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
    color: coreColors.textSecondary,
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
    backgroundColor: coreColors.white,
    borderRadius: 12,
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
    marginTop: spacing.md,
  },
  successMessage: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.xs,
    marginBottom: spacing.lg,
  },
});
