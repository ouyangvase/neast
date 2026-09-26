import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation } from '@tanstack/react-query';

import { sessionStore } from '@neast/types';
import {
  BrandHeader,
  Button,
  coreColors,
  OtpInput,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { navigateAfterAuth } from '@/lib/auth';
import { login, register, sendCode } from '@/lib/endpoints';
import { useCountdown } from '@/hooks/use-countdown';
import { Screen } from '@/components/Screen';

/** OTP verification (verify_screen parity): 6-digit code + 60s resend countdown. */
export default function VerifyRoute() {
  const params = useLocalSearchParams<{
    phone: string;
    mode: string;
    firstName: string;
    lastName: string;
  }>();
  const phone = params.phone ?? '';
  const isSignup = params.mode === 'signup';
  const firstName = params.firstName ?? '';
  const lastName = params.lastName ?? '';

  const [code, setCode] = useState('');
  const [hasError, setHasError] = useState(false);
  const countdown = useCountdown(60);

  const verifyMutation = useMutation({
    mutationFn: (value: string) =>
      isSignup
        ? register({ phone, code: value, first_name: firstName, last_name: lastName })
        : login({ phone, code: value }),
    onSuccess: async (response) => {
      await sessionStore.getState().setSession({
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresTime: response.expiresTime,
      });
      navigateAfterAuth();
    },
    onError: (error) => {
      setHasError(true);
      Toast.error(apiErrorMessage(error, 'Invalid code. Please try again.'));
    },
  });

  const resendMutation = useMutation({
    mutationFn: () => sendCode({ phone, scene: isSignup ? 'register' : 'login' }),
    onSuccess: () => {
      Toast.success('Code sent');
      countdown.restart();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const submit = (value: string) => {
    setHasError(false);
    verifyMutation.mutate(value);
  };

  return (
    <Screen>
      <BrandHeader title="Verification" onBack={() => router.back()} />
      <View style={styles.body}>
        <Text style={styles.title}>Enter verification code</Text>
        <Text style={styles.subtitle}>
          We sent a 6-digit code to <Text style={styles.contact}>+{phone}</Text>
        </Text>

        <OtpInput
          value={code}
          onChange={(value) => {
            setCode(value);
            setHasError(false);
          }}
          onComplete={submit}
          hasError={hasError}
          autoFocus
          style={styles.otp}
        />

        <Button
          title="Verify"
          onPress={() => submit(code)}
          loading={verifyMutation.isPending}
          disabled={code.length !== 6}
          style={styles.submit}
        />

        <View style={styles.resendRow}>
          {countdown.active ? (
            <Text style={styles.resendHint}>Resend code in {countdown.remaining}s</Text>
          ) : (
            <Pressable
              onPress={() => resendMutation.mutate()}
              disabled={resendMutation.isPending}
              accessibilityRole="button"
            >
              <Text style={styles.resendLink}>Resend code</Text>
            </Pressable>
          )}
        </View>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    padding: spacing.lg,
  },
  title: {
    ...textStyles.heading1,
  },
  subtitle: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.sm,
  },
  contact: {
    fontWeight: '600',
    color: coreColors.blackText,
  },
  otp: {
    marginTop: spacing.xl,
  },
  submit: {
    marginTop: spacing.xl,
  },
  resendRow: {
    alignItems: 'center',
    marginTop: spacing.lg,
  },
  resendHint: {
    ...textStyles.bodySmall,
    color: coreColors.textHint,
  },
  resendLink: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
});
