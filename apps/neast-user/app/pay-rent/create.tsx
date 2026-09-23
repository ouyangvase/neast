import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import {
  BottomSheet,
  BrandHeader,
  Button,
  Card,
  coreColors,
  spacing,
  TextField,
  textStyles,
  Toast,
  UploadProgressDialog,
} from '@neast/ui-mobile';

import connectIcon from '../../assets/images/pay_rent/connect-with-owner.png';
import agreementIcon from '../../assets/images/pay_rent/tenancy-agreement.png';

import { apiErrorMessage } from '../../src/lib/api';
import { openScanner } from '../../src/lib/callbacks';
import { createRent, getRentConnectOptions, getRentPropertyBySn } from '../../src/lib/endpoints';
import {
  LEASE_MONTH_OPTIONS,
  monthOptionLabel,
  monthOptionValue,
  ordinalDay,
  upcomingMonths,
  type MonthOption,
} from '../../src/lib/format';
import { pickDocumentFile, pickImageFile } from '../../src/lib/pickers';
import { useFileUpload } from '../../src/hooks/use-upload';
import { Screen } from '../../src/components/Screen';

const DAY_OPTIONS = Array.from({ length: 31 }, (_, index) => index + 1);

interface ConnectedProperty {
  propertyId?: number;
  propertyName: string;
  ownerName?: string;
}

/** Add-tenancy form (pay_rent_create_screen parity). */
export default function PayRentCreateRoute() {
  const queryClient = useQueryClient();
  const upload = useFileUpload();

  const [connected, setConnected] = useState<ConnectedProperty | null>(null);
  const [propertyName, setPropertyName] = useState('');
  const [amount, setAmount] = useState('');
  const [payDay, setPayDay] = useState(1);
  const now = new Date();
  const [firstPayMonth, setFirstPayMonth] = useState<MonthOption>({
    year: now.getFullYear(),
    month: now.getMonth() + 1,
  });
  const [leaseMonths, setLeaseMonths] = useState(12);
  const [agreementPath, setAgreementPath] = useState<string | null>(null);
  const [agreementName, setAgreementName] = useState<string | null>(null);

  const [dayPickerVisible, setDayPickerVisible] = useState(false);
  const [monthPickerVisible, setMonthPickerVisible] = useState(false);
  const [leasePickerVisible, setLeasePickerVisible] = useState(false);
  const [connectPickerVisible, setConnectPickerVisible] = useState(false);
  const [agreementPickerVisible, setAgreementPickerVisible] = useState(false);

  // Mock-only endpoint (absent from the real API) — failure just hides the picker.
  const connectOptions = useQuery({
    queryKey: ['rent-connect-options'],
    queryFn: getRentConnectOptions,
    enabled: connectPickerVisible,
  });

  const scanConnect = () => {
    openScanner((value) => {
      const sn = value.trim();
      if (!sn) return;
      getRentPropertyBySn(sn)
        .then((property) => {
          setConnected({
            propertyId: property.id,
            propertyName: property.name,
            ownerName: property.landlord_name,
          });
          setPropertyName(property.name);
          Toast.success(`Connected to ${property.name}`);
        })
        .catch((error: unknown) => Toast.error(apiErrorMessage(error, 'Property not found')));
    });
  };

  const createMutation = useMutation({
    mutationFn: createRent,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      Toast.success('Tenancy submitted for review');
      router.back();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const pickAgreement = async (source: 'image' | 'document') => {
    const file = source === 'image' ? await pickImageFile() : await pickDocumentFile();
    if (!file) return;
    const path = await upload.upload(file);
    if (path) {
      setAgreementPath(path);
      setAgreementName(file.name);
    }
  };

  const submit = () => {
    const numericAmount = Number(amount);
    if (!propertyName.trim()) {
      Toast.error('Please enter the property name');
      return;
    }
    if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
      Toast.error('Please enter a valid monthly rent amount');
      return;
    }
    if (!agreementPath) {
      Toast.error('Please upload your tenancy agreement');
      return;
    }
    createMutation.mutate({
      amount: numericAmount.toFixed(2),
      file: agreementPath,
      paid_at: String(payDay),
      first_pay_month: monthOptionValue(firstPayMonth),
      lease_months: leaseMonths,
      property_name: propertyName.trim(),
      property_id: connected?.propertyId,
      owner_name: connected?.ownerName,
    });
  };

  return (
    <Screen>
      <BrandHeader title="Add Tenancy" onBack={() => router.back()} />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <Card style={styles.connectCard} onPress={scanConnect}>
          <Image source={connectIcon} style={styles.connectIcon} resizeMode="contain" />
          <View style={styles.connectText}>
            <Text style={styles.connectTitle}>Connect with owner</Text>
            <Text style={styles.connectSubtitle}>
              {connected?.ownerName
                ? `Connected: ${connected.ownerName} · ${connected.propertyName}`
                : "Scan the owner's property QR code"}
            </Text>
          </View>
        </Card>
        <Pressable onPress={() => setConnectPickerVisible(true)} accessibilityRole="button">
          <Text style={styles.demoLink}>Or pick from a demo property</Text>
        </Pressable>

        <TextField
          label="Property name"
          value={propertyName}
          onChangeText={(value) => {
            setPropertyName(value);
            setConnected(null);
          }}
        />
        <TextField
          label="Monthly rent (RM)"
          value={amount}
          onChangeText={setAmount}
          keyboardType="decimal-pad"
          placeholder="0.00"
        />

        <SelectorRow
          label="Pay day of month"
          value={ordinalDay(payDay)}
          onPress={() => setDayPickerVisible(true)}
        />
        <SelectorRow
          label="First payment month"
          value={monthOptionLabel(firstPayMonth)}
          onPress={() => setMonthPickerVisible(true)}
        />
        <SelectorRow
          label="Lease duration"
          value={`${leaseMonths} months`}
          onPress={() => setLeasePickerVisible(true)}
        />

        <Card style={styles.agreementCard} onPress={() => setAgreementPickerVisible(true)}>
          <Image source={agreementIcon} style={styles.agreementIcon} resizeMode="contain" />
          <View style={styles.connectText}>
            <Text style={styles.connectTitle}>Tenancy agreement</Text>
            <Text style={styles.connectSubtitle}>
              {agreementName ?? 'Upload a photo or PDF of your agreement'}
            </Text>
          </View>
        </Card>

        <Button
          title="Submit"
          onPress={submit}
          loading={createMutation.isPending}
          style={styles.submit}
        />
      </ScrollView>

      <UploadProgressDialog
        visible={upload.progress !== null}
        progress={upload.progress ?? 0}
        fileName={upload.fileName}
        title="Uploading agreement"
        onCancel={upload.cancel}
      />

      <BottomSheet
        visible={dayPickerVisible}
        onClose={() => setDayPickerVisible(false)}
        title="Pay day of month"
      >
        <ScrollView style={styles.pickerScroll}>
          {DAY_OPTIONS.map((day) => (
            <PickerOption
              key={day}
              label={ordinalDay(day)}
              onPress={() => {
                setPayDay(day);
                setDayPickerVisible(false);
              }}
            />
          ))}
        </ScrollView>
      </BottomSheet>

      <BottomSheet
        visible={monthPickerVisible}
        onClose={() => setMonthPickerVisible(false)}
        title="First payment month"
      >
        <ScrollView style={styles.pickerScroll}>
          {upcomingMonths().map((option) => (
            <PickerOption
              key={monthOptionValue(option)}
              label={monthOptionLabel(option)}
              onPress={() => {
                setFirstPayMonth(option);
                setMonthPickerVisible(false);
              }}
            />
          ))}
        </ScrollView>
      </BottomSheet>

      <BottomSheet
        visible={leasePickerVisible}
        onClose={() => setLeasePickerVisible(false)}
        title="Lease duration"
      >
        {LEASE_MONTH_OPTIONS.map((months) => (
          <PickerOption
            key={months}
            label={`${months} months`}
            onPress={() => {
              setLeaseMonths(months);
              setLeasePickerVisible(false);
            }}
          />
        ))}
      </BottomSheet>

      <BottomSheet
        visible={agreementPickerVisible}
        onClose={() => setAgreementPickerVisible(false)}
        title="Upload agreement"
      >
        <PickerOption
          label="Choose photo"
          onPress={() => {
            setAgreementPickerVisible(false);
            void pickAgreement('image');
          }}
        />
        <PickerOption
          label="Choose file"
          onPress={() => {
            setAgreementPickerVisible(false);
            void pickAgreement('document');
          }}
        />
      </BottomSheet>

      <BottomSheet
        visible={connectPickerVisible}
        onClose={() => setConnectPickerVisible(false)}
        title="Demo properties"
      >
        {connectOptions.isLoading ? (
          <Text style={styles.sheetHint}>Loading…</Text>
        ) : (connectOptions.data?.items.length ?? 0) === 0 ? (
          <Text style={styles.sheetHint}>
            No demo properties available. Scan the owner&apos;s QR code instead.
          </Text>
        ) : (
          (connectOptions.data?.items ?? []).map((option) => (
            <PickerOption
              key={option.id}
              label={`${option.name} · ${option.landlord_name}`}
              onPress={() => {
                setConnected({
                  propertyId: option.id,
                  propertyName: option.name,
                  ownerName: option.landlord_name,
                });
                setPropertyName(option.name);
                setConnectPickerVisible(false);
              }}
            />
          ))
        )}
      </BottomSheet>
    </Screen>
  );
}

function SelectorRow({
  label,
  value,
  onPress,
}: {
  label: string;
  value: string;
  onPress: () => void;
}) {
  return (
    <View>
      <Text style={styles.selectorLabel}>{label}</Text>
      <Pressable style={styles.selector} onPress={onPress} accessibilityRole="button">
        <Text style={styles.selectorValue}>{value}</Text>
      </Pressable>
    </View>
  );
}

function PickerOption({ label, onPress }: { label: string; onPress: () => void }) {
  return (
    <Pressable style={styles.option} onPress={onPress} accessibilityRole="button">
      <Text style={styles.optionText}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
    paddingBottom: spacing.xxl,
  },
  connectCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  connectIcon: {
    width: 40,
    height: 40,
  },
  connectText: {
    flex: 1,
    gap: 2,
  },
  connectTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  connectSubtitle: {
    ...textStyles.caption,
  },
  demoLink: {
    ...textStyles.caption,
    color: coreColors.brandBlue,
    textAlign: 'right',
  },
  selectorLabel: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    marginBottom: spacing.sm,
  },
  selector: {
    borderWidth: 1,
    borderColor: coreColors.border,
    borderRadius: 8,
    backgroundColor: coreColors.white,
    paddingHorizontal: spacing.md,
    minHeight: 48,
    justifyContent: 'center',
  },
  selectorValue: {
    ...textStyles.body,
  },
  agreementCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  agreementIcon: {
    width: 40,
    height: 40,
  },
  submit: {
    marginTop: spacing.sm,
  },
  pickerScroll: {
    maxHeight: 320,
  },
  option: {
    paddingVertical: spacing.md,
  },
  optionText: {
    ...textStyles.body,
  },
  sheetHint: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    paddingVertical: spacing.lg,
  },
});
