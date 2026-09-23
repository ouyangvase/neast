import { useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
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
  TextField,
  textStyles,
  Toast,
  useUiTheme,
} from '@neast/ui-mobile';

import logo from '../assets/images/app_header.png';

import { apiErrorMessage } from '../src/lib/api';
import { getCountryCodes, sendCode } from '../src/lib/endpoints';
import { Screen } from '../src/components/Screen';

type AuthMode = 'login' | 'signup';

/** Login (login_screen parity): phone OTP tabs — Log in / Sign up, default +60. */
export default function LoginRoute() {
  const theme = useUiTheme();
  const [mode, setMode] = useState<AuthMode>('login');
  const [dialCode, setDialCode] = useState('+60');
  const [phone, setPhone] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [pickerVisible, setPickerVisible] = useState(false);
  const [error, setError] = useState<string | undefined>(undefined);

  const countryCodes = useQuery({
    queryKey: ['country-codes'],
    queryFn: getCountryCodes,
    staleTime: Infinity,
  });

  const sendMutation = useMutation({
    mutationFn: (account: string) =>
      sendCode({ phone: account, scene: mode === 'login' ? 'login' : 'register' }),
    onSuccess: (_data, account) => {
      router.push({
        pathname: '/verify',
        params: { phone: account, mode, firstName, lastName },
      });
    },
    onError: (mutationError) => Toast.error(apiErrorMessage(mutationError)),
  });

  const submit = () => {
    if (mode === 'signup' && (!firstName.trim() || !lastName.trim())) {
      setError('Enter your first and last name');
      return;
    }
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
          <Text style={styles.headerTitle}>Welcome to NEAST Owner</Text>
          <Text style={styles.headerSubtitle}>Manage your properties and tenants</Text>
        </GradientHeader>

        <View style={styles.tabs}>
          {(['login', 'signup'] as const).map((value) => (
            <Pressable
              key={value}
              style={[styles.tab, mode === value && styles.tabActive]}
              onPress={() => {
                setMode(value);
                setError(undefined);
              }}
              accessibilityRole="button"
            >
              <Text style={[styles.tabText, mode === value && styles.tabTextActive]}>
                {value === 'login' ? 'Log In' : 'Sign Up'}
              </Text>
            </Pressable>
          ))}
        </View>

        <View style={styles.form}>
          {mode === 'signup' ? (
            <View style={styles.nameRow}>
              <TextField
                label="First name"
                value={firstName}
                onChangeText={setFirstName}
                autoCapitalize="words"
                containerStyle={styles.nameField}
              />
              <TextField
                label="Last name"
                value={lastName}
                onChangeText={setLastName}
                autoCapitalize="words"
                containerStyle={styles.nameField}
              />
            </View>
          ) : null}
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
  tabs: {
    flexDirection: 'row',
    marginHorizontal: spacing.lg,
    marginTop: spacing.lg,
    borderRadius: 8,
    backgroundColor: coreColors.appBarBackground,
    padding: 4,
  },
  tab: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderRadius: 6,
  },
  tabActive: {
    backgroundColor: coreColors.white,
  },
  tabText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    fontWeight: '600',
  },
  tabTextActive: {
    color: coreColors.brandBlue,
  },
  form: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  nameRow: {
    flexDirection: 'row',
    gap: spacing.md,
  },
  nameField: {
    flex: 1,
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
