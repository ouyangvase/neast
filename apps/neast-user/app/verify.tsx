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
import { login, sendCode } from '@/lib/endpoints';
import { useCountdown } from '@/hooks/use-countdown';

/** OTP verification on the home metallic background, with a white sheet for the code. */
export default function VerifyRoute() {
  const insets = useSafeAreaInsets();
  const { contact } = useLocalSearchParams<{ contact: string }>();
  const account = contact ?? '';

  const [code, setCode] = useState(
    __DEV__ &&
      (account === '60123456789' ||
        account === '60111111111' ||
        account === '60222222222' ||
        account === '60333333333' ||
        account === '60444444444' ||
        account === '60555555555' ||
        account === '60666666666' ||
        account === '60777777777' ||
        account === '60888888888')
      ? '123456'
      : '',
  );
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
            We sent a 6-digit code to <Text style={styles.contact}>+{account}</Text>
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
            loading={loginMutation.isPending}
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
    // Left chevron stroke sits 3.5px left of its box.
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
