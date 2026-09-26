import { useState, type ReactNode } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { DAY_OPTIONS, LEASE_MONTH_OPTIONS } from '@neast/constant';
import {
  BottomSheet,
  Button,
  Card,
  DocumentIcon,
  MonthPicker,
  SelectField,
  spacing,
  TextField,
  textStyles,
  Toast,
  UploadIcon,
  UploadProgressDialog,
  userHomeColors,
} from '@neast/ui-mobile';

import { monthOptionLabel, monthOptionValue, ordinalDay, upcomingMonths } from '@/lib/format';
import { pickDocumentFile, pickImageFile } from '@/lib/pickers';
import { useFileUpload } from '@/hooks/use-upload';

export interface TenancyFormValues {
  amount: string;
  file: string;
  paid_at: string;
  first_pay_month: string;
  lease_months: number;
}

export interface TenancyFormInitial {
  amount: string;
  paidAt: number;
  /** `Y-m`. */
  firstPayMonth: string;
  leaseMonths: number;
  file: string;
}

/** Shared rent fields, agreement upload, and footer submit for both add-tenancy pages. */
export function TenancyForm({
  leading,
  submitting,
  submitLabel = 'Submit',
  initial,
  onSubmit,
}: {
  leading: ReactNode;
  submitting: boolean;
  submitLabel?: string;
  initial?: TenancyFormInitial;
  onSubmit: (values: TenancyFormValues) => void;
}) {
  const insets = useSafeAreaInsets();
  const upload = useFileUpload();
  const now = new Date();
  const [amount, setAmount] = useState(initial?.amount ?? '');
  const [payDay, setPayDay] = useState(initial?.paidAt ?? 1);
  const [firstPayMonth, setFirstPayMonth] = useState(
    initial
      ? {
          year: Number(initial.firstPayMonth.slice(0, 4)),
          month: Number(initial.firstPayMonth.slice(5, 7)),
        }
      : { year: now.getFullYear(), month: now.getMonth() + 1 },
  );
  const [leaseMonths, setLeaseMonths] = useState(initial?.leaseMonths ?? 12);
  const [agreementPath, setAgreementPath] = useState<string | null>(initial?.file ?? null);
  const [agreementName, setAgreementName] = useState<string | null>(
    initial ? initial.file.slice(initial.file.lastIndexOf('/') + 1) : null,
  );

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
    const file = __DEV__ ? '/uploads/rent/local-test-agreement.jpg' : agreementPath;
    if (!file) {
      Toast.error('Please upload your tenancy agreement');
      return;
    }
    onSubmit({
      amount,
      file,
      paid_at: String(payDay),
      first_pay_month: monthOptionValue(firstPayMonth),
      lease_months: leaseMonths,
    });
  };

  return (
    <View style={styles.body}>
      <ScrollView
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.scroll}
      >
        <Card style={styles.fields}>
          {leading}
          <TextField
            label="Monthly rent (RM)"
            value={amount}
            onChangeText={setAmount}
            keyboardType="decimal-pad"
            placeholder="0.00"
          />
          <SelectField
            label="Pay day of month"
            value={ordinalDay(payDay)}
            onPress={() => setDayPickerVisible(true)}
          />
          <SelectField
            label="First payment month"
            value={monthOptionLabel(firstPayMonth)}
            onPress={() => setMonthPickerVisible(true)}
          />
          <SelectField
            label="Lease duration"
            value={`${leaseMonths} months`}
            onPress={() => setLeasePickerVisible(true)}
          />
          {__DEV__ ? null : (
            <SelectField
              label="Tenancy agreement"
              value={agreementName ?? undefined}
              placeholder="Upload a photo or PDF"
              left={
                agreementName ? (
                  <DocumentIcon size={20} color={userHomeColors.navy} />
                ) : (
                  <UploadIcon size={20} color={userHomeColors.navy} />
                )
              }
              onPress={() => setAgreementPickerVisible(true)}
            />
          )}
        </Card>
      </ScrollView>

      <View style={[styles.footer, { paddingBottom: insets.bottom + spacing.md }]}>
        <Button title={submitLabel} onPress={submit} loading={submitting} />
      </View>

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
        <View style={styles.dayGrid}>
          {DAY_OPTIONS.map((day) => {
            const selected = day === payDay;
            return (
              <Pressable
                key={day}
                accessibilityRole="button"
                accessibilityState={{ selected }}
                onPress={() => {
                  setPayDay(day);
                  setDayPickerVisible(false);
                }}
                style={styles.dayCell}
              >
                <View style={[styles.dayDot, selected && styles.dayDotSelected]}>
                  <Text style={[styles.dayText, selected && styles.dayTextSelected]}>{day}</Text>
                </View>
              </Pressable>
            );
          })}
        </View>
      </BottomSheet>

      <MonthPicker
        visible={monthPickerVisible}
        onClose={() => setMonthPickerVisible(false)}
        onSelect={setFirstPayMonth}
        selected={firstPayMonth}
        months={upcomingMonths()}
        title="First payment month"
      />

      <BottomSheet
        visible={leasePickerVisible}
        onClose={() => setLeasePickerVisible(false)}
        title="Lease duration"
      >
        {LEASE_MONTH_OPTIONS.map((months) => (
          <PickerOption
            key={months}
            label={`${months} months`}
            selected={months === leaseMonths}
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

function PickerOption({
  label,
  selected = false,
  onPress,
}: {
  label: string;
  selected?: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      style={[styles.option, selected && styles.optionSelected]}
      onPress={onPress}
      accessibilityRole="button"
      accessibilityState={{ selected }}
    >
      <Text style={[styles.optionText, selected && styles.optionTextSelected]}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scroll: {
    padding: spacing.lg,
  },
  fields: {
    gap: spacing.lg,
  },
  footer: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    backgroundColor: userHomeColors.background,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: userHomeColors.border,
  },
  dayGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  dayCell: {
    width: `${100 / 7}%`,
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayDot: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayDotSelected: {
    backgroundColor: userHomeColors.navy,
  },
  dayText: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  dayTextSelected: {
    color: userHomeColors.surface,
  },
  option: {
    minHeight: 48,
    justifyContent: 'center',
    paddingHorizontal: spacing.sm,
    borderRadius: 8,
  },
  optionSelected: {
    backgroundColor: userHomeColors.lightBlue,
  },
  optionText: {
    ...textStyles.body,
  },
  optionTextSelected: {
    color: userHomeColors.navy,
    fontWeight: '600',
  },
});
