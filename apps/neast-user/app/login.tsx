import { useState } from 'react';
import { Image, ImageBackground, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery } from '@tanstack/react-query';

import { joinPhoneAccount } from '@neast/types';
import { Button, CountryCodePicker, PhoneField, Toast, userHomeColors } from '@neast/ui-mobile';

import logo from '@assets/images/home/hone_logo.png';
import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { apiErrorMessage } from '@/lib/api';
import { getCountryCodes, sendCode } from '@/lib/endpoints';

/** Login: phone OTP on the home metallic background, with a white sheet for the form. */
export default function LoginRoute() {
  const insets = useSafeAreaInsets();
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
          <Text style={styles.title}>Welcome to NEAST</Text>
          <Text style={styles.subtitle}>Log in with your phone number</Text>
        </ImageBackground>

        <View style={[styles.sheet, { paddingBottom: insets.bottom + 24 }]}>
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
    width: 48,
    height: 36,
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
