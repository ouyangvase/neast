import { useEffect, useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

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

import { apiErrorMessage } from '../src/lib/api';
import { getLandlordInfo, updateBankDetail } from '../src/lib/endpoints';
import { pickImageFile } from '../src/lib/pickers';
import { useFileUpload } from '../src/hooks/use-upload';
import { LoadingState } from '../src/components/StateViews';
import { Screen } from '../src/components/Screen';

/** Bank detail (bank_detail_screen parity): payout bank form + bank-header photo upload. */
export default function BankDetailRoute() {
  const queryClient = useQueryClient();
  const info = useQuery({ queryKey: ['landlord-info'], queryFn: getLandlordInfo });

  const [bankName, setBankName] = useState('');
  const [bankAccount, setBankAccount] = useState('');
  const [holderName, setHolderName] = useState('');
  const [photoPath, setPhotoPath] = useState('');
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const uploader = useFileUpload();

  // Prefill once the profile arrives.
  useEffect(() => {
    const data = info.data;
    if (!data) return;
    setBankName(data.bank_name ?? '');
    setBankAccount(data.bank_account ?? '');
    setHolderName(data.account_holder_name ?? '');
    setPhotoPath(data.bank_header_photo ?? '');
    setPhotoPreview(data.bank_header_photo_url || null);
  }, [info.data]);

  const saveMutation = useMutation({
    mutationFn: () =>
      updateBankDetail({
        bank_name: bankName.trim(),
        bank_account: bankAccount.trim(),
        account_holder_name: holderName.trim(),
        bank_header_photo: photoPath,
      }),
    onSuccess: async () => {
      Toast.success('Bank detail saved');
      await queryClient.invalidateQueries({ queryKey: ['landlord-info'] });
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const pickPhoto = async () => {
    const file = await pickImageFile();
    if (!file) return;
    const path = await uploader.upload(file);
    if (path) {
      setPhotoPath(path);
      setPhotoPreview(file.uri);
    }
  };

  const ready =
    bankName.trim() !== '' &&
    bankAccount.trim() !== '' &&
    holderName.trim() !== '' &&
    photoPath !== '';

  return (
    <Screen>
      <BrandHeader title="Bank Detail" onBack={() => router.back()} />
      {info.isLoading ? (
        <LoadingState />
      ) : (
        <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
          <TextField label="Bank name" value={bankName} onChangeText={setBankName} />
          <TextField
            label="Bank account"
            value={bankAccount}
            onChangeText={setBankAccount}
            keyboardType="number-pad"
          />
          <TextField
            label="Account holder name"
            value={holderName}
            onChangeText={setHolderName}
            autoCapitalize="words"
          />

          <Text style={styles.sectionLabel}>Bank header photo</Text>
          <Pressable onPress={pickPhoto} accessibilityRole="button" style={styles.uploadTile}>
            <Image
              source={photoPreview ? { uri: photoPreview } : photoUpload}
              style={photoPreview ? styles.uploadPreview : styles.uploadPlaceholder}
              resizeMode="cover"
            />
            <Text style={styles.uploadText}>
              {photoPath ? 'Tap to replace the photo' : 'Tap to upload a photo'}
            </Text>
          </Pressable>

          <Button
            title="Save"
            onPress={() => saveMutation.mutate()}
            disabled={!ready}
            loading={saveMutation.isPending}
            style={styles.submit}
          />
        </ScrollView>
      )}

      <UploadProgressDialog
        visible={uploader.progress !== null}
        progress={uploader.progress ?? 0}
        fileName={uploader.fileName}
        onCancel={uploader.cancel}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
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
});
