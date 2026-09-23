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

import { apiErrorMessage } from '../src/lib/api';
import { navigateAfterAuth } from '../src/lib/auth';
import { login, sendCode } from '../src/lib/endpoints';
import { useCountdown } from '../src/hooks/use-countdown';
import { Screen } from '../src/components/Screen';

/** OTP verification (verify_screen parity): pinput + 60s resend countdown. */
export default function VerifyRoute() {
  const { contact } = useLocalSearchParams<{ contact: string }>();
  const account = contact ?? '';

  const [code, setCode] = useState('');
  const [hasError, setHasError] = useState(false);
  const countdown = useCountdown(60);

  const loginMutation = useMutation({
    mutationFn: (value: string) => login({ account, code: value }),
    onSuccess: async (response) => {
      await sessionStore.getState().setSession({
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresTime: response.expiresTime,
      });
      if (!response.profileCompleted) {
        router.replace('/full-data');
        return;
      }
      navigateAfterAuth();
    },
    onError: (error) => {
      setHasError(true);
      Toast.error(apiErrorMessage(error, 'Invalid code. Please try again.'));
    },
  });

  const resendMutation = useMutation({
    mutationFn: () => sendCode(account),
    onSuccess: () => {
      Toast.success('Code sent');
      countdown.restart();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const submit = (value: string) => {
    setHasError(false);
    loginMutation.mutate(value);
  };

  return (
    <Screen>
      <BrandHeader title="Verification" onBack={() => router.back()} />
      <View style={styles.body}>
        <Text style={styles.title}>Enter verification code</Text>
        <Text style={styles.subtitle}>
          We sent a 6-digit code to <Text style={styles.contact}>+{account}</Text>
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
          loading={loginMutation.isPending}
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
