import { useState, type ReactNode } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { DAY_OPTIONS } from '@neast/constant';
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

import {
  agreementFromMonths,
  agreementToMonths,
  clampMonth,
  currentMonth,
  firstPayMonths,
  monthOptionLabel,
  monthOptionValue,
  ordinalDay,
  shiftMonth,
  type MonthOption,
} from '@/lib/format';
import { pickDocumentFile, pickImageFile } from '@/lib/pickers';
import { useFileUpload } from '@/hooks/use-upload';

export interface TenancyFormValues {
  amount: string;
  file: string;
  paid_at: string;
  /** `Y-m`. */
  agreement_start: string;
  /** `Y-m`. */
  agreement_end: string;
  /** `Y-m`. */
  first_pay_month: string;
}

export interface TenancyFormInitial {
  amount: string;
  paidAt: number;
  /** `Y-m`. */
  agreementStart: string;
  /** `Y-m`. */
  agreementEnd: string;
  /** `Y-m`. */
  firstPayMonth: string;
  file: string;
}

function parseYearMonth(value: string): MonthOption {
  return {
    year: Number(value.slice(0, 4)),
    month: Number(value.slice(5, 7)),
  };
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
  const today = currentMonth();
  const startingFrom = clampMonth(
    initial ? parseYearMonth(initial.agreementStart) : today,
    agreementFromMonths(),
  );
  const startingTo = clampMonth(
    initial ? parseYearMonth(initial.agreementEnd) : shiftMonth(today, 11),
    agreementToMonths(startingFrom),
  );
  const [amount, setAmount] = useState(initial?.amount ?? '');
  const [payDay, setPayDay] = useState(initial?.paidAt ?? 1);
  const [agreementFrom, setAgreementFrom] = useState(startingFrom);
  const [agreementTo, setAgreementTo] = useState(startingTo);
  const [firstPayMonth, setFirstPayMonth] = useState(
    clampMonth(
      initial ? parseYearMonth(initial.firstPayMonth) : today,
      firstPayMonths(startingFrom, startingTo),
    ),
  );
  const [agreementPath, setAgreementPath] = useState<string | null>(initial?.file ?? null);
  const [agreementName, setAgreementName] = useState<string | null>(
    initial ? initial.file.slice(initial.file.lastIndexOf('/') + 1) : null,
  );

  const [dayPickerVisible, setDayPickerVisible] = useState(false);
  const [fromPickerVisible, setFromPickerVisible] = useState(false);
  const [toPickerVisible, setToPickerVisible] = useState(false);
  const [monthPickerVisible, setMonthPickerVisible] = useState(false);
  const [agreementPickerVisible, setAgreementPickerVisible] = useState(false);

  const selectAgreementFrom = (value: MonthOption) => {
    const nextTo = clampMonth(agreementTo, agreementToMonths(value));
    setAgreementFrom(value);
    setAgreementTo(nextTo);
    setFirstPayMonth(clampMonth(firstPayMonth, firstPayMonths(value, nextTo)));
  };

  const selectAgreementTo = (value: MonthOption) => {
    setAgreementTo(value);
    setFirstPayMonth(clampMonth(firstPayMonth, firstPayMonths(agreementFrom, value)));
  };

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
      agreement_start: monthOptionValue(agreementFrom),
      agreement_end: monthOptionValue(agreementTo),
      first_pay_month: monthOptionValue(firstPayMonth),
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
            label="Agreement from"
            value={monthOptionLabel(agreementFrom)}
            onPress={() => setFromPickerVisible(true)}
          />
          <SelectField
            label="Agreement to"
            value={monthOptionLabel(agreementTo)}
            onPress={() => setToPickerVisible(true)}
          />
          <SelectField
            label="First payment month on NEAST"
            value={monthOptionLabel(firstPayMonth)}
            onPress={() => setMonthPickerVisible(true)}
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
        visible={fromPickerVisible}
        onClose={() => setFromPickerVisible(false)}
        onSelect={selectAgreementFrom}
        selected={agreementFrom}
        months={agreementFromMonths()}
        title="Agreement from"
      />

      <MonthPicker
        visible={toPickerVisible}
        onClose={() => setToPickerVisible(false)}
        onSelect={selectAgreementTo}
        selected={agreementTo}
        months={agreementToMonths(agreementFrom)}
        title="Agreement to"
      />

      <MonthPicker
        visible={monthPickerVisible}
        onClose={() => setMonthPickerVisible(false)}
        onSelect={setFirstPayMonth}
        selected={firstPayMonth}
        months={firstPayMonths(agreementFrom, agreementTo)}
        title="First payment month on NEAST"
      />

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
