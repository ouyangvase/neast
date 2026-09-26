import { useState } from 'react';
import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery } from '@tanstack/react-query';

import { joinPhoneAccount } from '@neast/types';
import {
  Button,
  coreColors,
  CountryCodePicker,
  GradientHeader,
  PhoneField,
  spacing,
  textStyles,
  Toast,
  useUiTheme,
} from '@neast/ui-mobile';

import logo from '@assets/images/home/hone_logo.png';

import { apiErrorMessage } from '@/lib/api';
import { getCountryCodes, sendCode } from '@/lib/endpoints';
import { Screen } from '@/components/Screen';

/** Login (login_screen parity): phone OTP, country-code picker, default +60. */
export default function LoginRoute() {
  const theme = useUiTheme();
  const [dialCode, setDialCode] = useState('+60');
  const [phone, setPhone] = useState(__DEV__ ? '111111111' : '');
  const [pickerVisible, setPickerVisible] = useState(false);
  const [error, setError] = useState<string | undefined>(undefined);

  const countryCodes = useQuery({
    queryKey: ['country-codes'],
    queryFn: getCountryCodes,
    staleTime: Infinity,
  });

  const sendMutation = useMutation({
    mutationFn: (account: string) => sendCode(account),
    onSuccess: (_data, account) => {
      router.push({ pathname: '/verify', params: { contact: account } });
    },
    onError: (mutationError) => Toast.error(apiErrorMessage(mutationError)),
  });

  const submit = () => {
    if (phone.length < 6) {
      setError('Enter a valid phone number');
      return;
    }
    setError(undefined);
    sendMutation.mutate(joinPhoneAccount(dialCode, phone));
  };

  const codes = (countryCodes.data ?? []).map((item) => item.code);

  return (
    <Screen edges={[]}>
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <GradientHeader colors={theme.gradients.header} style={styles.header}>
          <Image source={logo} style={styles.logo} resizeMode="contain" />
          <Text style={styles.headerTitle}>Welcome to NEAST</Text>
          <Text style={styles.headerSubtitle}>Log in with your phone number</Text>
        </GradientHeader>

        <View style={styles.form}>
          <PhoneField
            label="Phone number"
            dialCode={dialCode}
            onDialCodePress={() => setPickerVisible(true)}
            phone={phone}
            onPhoneChange={setPhone}
            error={error}
            autoFocus
          />
          <Button
            title="Send Code"
            onPress={submit}
            loading={sendMutation.isPending}
            style={styles.submit}
          />

          <Text style={styles.terms}>
            By continuing you agree to our{' '}
            <Text
              style={styles.termsLink}
              onPress={() =>
                router.push({ pathname: '/rich-text', params: { title: 'Terms and Conditions' } })
              }
            >
              Terms and Conditions
            </Text>{' '}
            and{' '}
            <Text
              style={styles.termsLink}
              onPress={() =>
                router.push({ pathname: '/rich-text', params: { title: 'Privacy Policy' } })
              }
            >
              Privacy Policy
            </Text>
            .
          </Text>
        </View>
      </ScrollView>

      <CountryCodePicker
        visible={pickerVisible}
        onClose={() => setPickerVisible(false)}
        codes={codes}
        selectedCode={dialCode}
        onSelect={setDialCode}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    flexGrow: 1,
  },
  header: {
    alignItems: 'center',
    paddingBottom: spacing.xxl,
  },
  logo: {
    width: 120,
    height: 44,
    marginTop: spacing.xl,
  },
  headerTitle: {
    ...textStyles.heading1,
    color: coreColors.white,
    marginTop: spacing.lg,
  },
  headerSubtitle: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    opacity: 0.85,
    marginTop: spacing.xs,
  },
  form: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  submit: {
    marginTop: spacing.sm,
  },
  terms: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: spacing.md,
  },
  termsLink: {
    color: coreColors.brandBlue,
  },
});
