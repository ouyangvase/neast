import { useState } from 'react';
import { ImageBackground, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation } from '@tanstack/react-query';

import { sessionStore } from '@neast/types';
import { Button, Chevron, OtpInput, Toast, userHomeColors } from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { apiErrorMessage } from '@/lib/api';
import { navigateAfterAuth } from '@/lib/auth';
import { login, register, sendCode } from '@/lib/endpoints';
import { useCountdown } from '@/hooks/use-countdown';

/** OTP verification on the metallic background, with a white sheet for the code. */
export default function VerifyRoute() {
  const insets = useSafeAreaInsets();
  const params = useLocalSearchParams<{
    phone: string;
    mode: string;
    firstName: string;
    lastName: string;
  }>();
  const phone = params.phone;
  const isSignup = params.mode === 'signup';
  const firstName = params.firstName;
  const lastName = params.lastName;

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
    <View style={styles.container}>
      <StatusBar style="light" />
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <ImageBackground
          source={metallicBackground}
          resizeMode="cover"
          style={[styles.hero, { paddingTop: insets.top + 8 }]}
        >
          <Pressable
            onPress={() => router.back()}
            accessibilityRole="button"
            accessibilityLabel="Back"
            hitSlop={12}
            style={styles.back}
          >
            <View style={styles.backIcon}>
              <Chevron direction="left" color={userHomeColors.surface} size={12} />
            </View>
          </Pressable>
          <Text style={styles.title}>Enter verification code</Text>
          <Text style={styles.subtitle}>
            We sent a 6-digit code to <Text style={styles.contact}>+{phone}</Text>
          </Text>
        </ImageBackground>

        <View style={[styles.sheet, { paddingBottom: insets.bottom + 24 }]}>
          <OtpInput
            value={code}
            onChange={(value) => {
              setCode(value);
              setHasError(false);
            }}
            onComplete={submit}
            hasError={hasError}
            autoFocus
          />
          <Button
            title="Verify"
            onPress={() => submit(code)}
            loading={verifyMutation.isPending}
            disabled={code.length !== 6}
            size="large"
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
      </ScrollView>
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
  back: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255,255,255,0.14)',
    marginBottom: 20,
  },
  backIcon: {
    transform: [{ translateX: 3.5 }],
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
  contact: {
    color: userHomeColors.gold,
    fontWeight: '700',
  },
  sheet: {
    flexGrow: 1,
    marginTop: -28,
    paddingHorizontal: 20,
    paddingTop: 28,
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  submit: {
    marginTop: 24,
    borderRadius: 16,
  },
  resendRow: {
    alignItems: 'center',
    marginTop: 20,
  },
  resendHint: {
    color: userHomeColors.textSecondary,
    fontSize: 14,
    lineHeight: 20,
  },
  resendLink: {
    color: userHomeColors.navy,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '700',
  },
});
