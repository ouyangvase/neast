import { useState } from 'react';
import { Image, ImageBackground, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery } from '@tanstack/react-query';

import { joinPhoneAccount } from '@neast/types';
import {
  Button,
  CountryCodePicker,
  PhoneField,
  spacing,
  TextField,
  Toast,
  userHomeColors,
} from '@neast/ui-mobile';

import logo from '@assets/images/app_header.png';
import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { apiErrorMessage } from '@/lib/api';
import { getCountryCodes, sendCode } from '@/lib/endpoints';

type AuthMode = 'login' | 'signup';

/** Login: phone OTP on the metallic background, with Log in / Sign up. */
export default function LoginRoute() {
  const insets = useSafeAreaInsets();
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
    <View style={styles.container}>
      <StatusBar style="light" />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <ImageBackground
          source={metallicBackground}
          resizeMode="cover"
          style={[styles.hero, { paddingTop: insets.top + 20 }]}
        >
          <Image
            source={logo}
            style={styles.logo}
            resizeMode="contain"
            accessibilityLabel="NEAST"
          />
          <Text style={styles.title}>Welcome to NEAST Owner</Text>
          <Text style={styles.subtitle}>Manage your properties and tenants</Text>
        </ImageBackground>

        <View style={[styles.sheet, { paddingBottom: insets.bottom + 24 }]}>
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
            title="Send code"
            onPress={submit}
            loading={sendMutation.isPending}
            size="large"
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.navy,
  },
  scroll: {
    flexGrow: 1,
  },
  hero: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 24,
    paddingBottom: 56,
  },
  logo: {
    width: 120,
    height: 44,
    marginBottom: 20,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 28,
    lineHeight: 34,
    fontWeight: '700',
    letterSpacing: -0.6,
  },
  subtitle: {
    color: userHomeColors.textOnNavyAlt,
    fontSize: 15,
    lineHeight: 22,
    marginTop: 8,
  },
  sheet: {
    flexGrow: 1,
    marginTop: -28,
    paddingHorizontal: 20,
    paddingTop: 28,
    gap: 16,
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  tabs: {
    flexDirection: 'row',
    borderRadius: 12,
    backgroundColor: userHomeColors.lightBlue,
    padding: 4,
  },
  tab: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderRadius: 8,
  },
  tabActive: {
    backgroundColor: userHomeColors.navy,
  },
  tabText: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    fontWeight: '600',
  },
  tabTextActive: {
    color: userHomeColors.surface,
  },
  nameRow: {
    flexDirection: 'row',
    gap: spacing.md,
  },
  nameField: {
    flex: 1,
  },
  submit: {
    borderRadius: 16,
  },
  terms: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 18,
    textAlign: 'center',
    marginTop: 8,
  },
  termsLink: {
    color: userHomeColors.navy,
    fontWeight: '600',
  },
});
