import { useState, type ReactNode } from 'react';
import { ActivityIndicator, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import {
  BottomSheet,
  Card,
  coreColors,
  spacing,
  TextField,
  textStyles,
  Toast,
  UploadProgressDialog,
  userHomeColors,
} from '@neast/ui-mobile';

import {
  LEASE_MONTH_OPTIONS,
  monthOptionLabel,
  monthOptionValue,
  ordinalDay,
  upcomingMonths,
  type MonthOption,
} from '../../lib/format';
import { pickDocumentFile, pickImageFile } from '../../lib/pickers';
import { useFileUpload } from '../../hooks/use-upload';

const DAY_OPTIONS = Array.from({ length: 31 }, (_, index) => index + 1);

export interface TenancyFormValues {
  amount: string;
  file: string;
  paid_at: string;
  first_pay_month: string;
  lease_months: number;
}

/** Shared rent fields, agreement upload, and floating submit for both add-tenancy pages. */
export function TenancyForm({
  leading,
  submitting,
  onSubmit,
}: {
  leading: ReactNode;
  submitting: boolean;
  onSubmit: (values: TenancyFormValues) => void;
}) {
  const insets = useSafeAreaInsets();
  const upload = useFileUpload();
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
  const [agreementPickerVisible, setAgreementPickerVisible] = useState(false);

  const pickAgreement = async (source: 'image' | 'document') => {
    const file = source === 'image' ? await pickImageFile() : await pickDocumentFile();
    if (!file) return;
    const uploaded = await upload.upload(file);
    if (uploaded) {
      setAgreementPath(uploaded);
      setAgreementName(file.name);
    }
  };

  const submit = () => {
    const numericAmount = Number(amount);
    if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
      Toast.error('Please enter a valid monthly rent amount');
      return;
    }
    if (!agreementPath) {
      Toast.error('Please upload your tenancy agreement');
      return;
    }
    onSubmit({
      amount,
      file: agreementPath,
      paid_at: String(payDay),
      first_pay_month: monthOptionValue(firstPayMonth),
      lease_months: leaseMonths,
    });
  };

  return (
    <View style={styles.flex}>
      <ScrollView
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={[styles.scroll, { paddingBottom: insets.bottom + 78 }]}
      >
        {leading}
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
          <Ionicons
            name={agreementName ? 'document-attach-outline' : 'cloud-upload-outline'}
            size={24}
            color={coreColors.brandBlue}
          />
          <View style={styles.agreementText}>
            <Text style={styles.agreementTitle}>Tenancy agreement</Text>
            <Text style={styles.agreementSubtitle}>
              {agreementName ?? 'Upload a photo or PDF of your agreement'}
            </Text>
          </View>
        </Card>
      </ScrollView>

      <Pressable
        accessibilityRole="button"
        disabled={submitting}
        onPress={submit}
        style={({ pressed }) => [
          styles.submit,
          { bottom: insets.bottom + 16 },
          pressed && styles.pressed,
        ]}
      >
        {submitting ? (
          <ActivityIndicator color={userHomeColors.surface} />
        ) : (
          <Text style={styles.submitText}>Submit</Text>
        )}
      </Pressable>

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
    </View>
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
  flex: {
    flex: 1,
  },
  scroll: {
    padding: spacing.lg,
    gap: spacing.md,
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
  agreementText: {
    flex: 1,
    gap: 2,
  },
  agreementTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  agreementSubtitle: {
    ...textStyles.caption,
  },
  submit: {
    position: 'absolute',
    left: 14,
    right: 14,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  submitText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
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
});
