import { useState } from 'react';
import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useMutation } from '@tanstack/react-query';

import { sessionStore } from '@neast/types';
import {
  Button,
  coreColors,
  GradientHeader,
  spacing,
  TextField,
  textStyles,
  Toast,
  useUiTheme,
} from '@neast/ui-mobile';

import logo from '../assets/images/app_header.png';

import { apiErrorMessage } from '../src/lib/api';
import { navigateAfterAuth } from '../src/lib/auth';
import { login } from '../src/lib/endpoints';
import { Screen } from '../src/components/Screen';

/** Login (login_screen parity): email + password only — no register, no OTP. */
export default function LoginRoute() {
  const theme = useUiTheme();
  const [account, setAccount] = useState('');
  const [password, setPassword] = useState('');

  const loginMutation = useMutation({
    mutationFn: () => login({ account: account.trim(), password }),
    onSuccess: async (data) => {
      await sessionStore.getState().setSession({
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
        expiresTime: data.expiresTime,
      });
      navigateAfterAuth();
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const submit = () => {
    if (!account.trim() || !password) {
      Toast.error('Please enter your email and password');
      return;
    }
    loginMutation.mutate();
  };

  return (
    <Screen edges={[]}>
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <GradientHeader colors={theme.gradients.header} style={styles.header}>
          <Image source={logo} style={styles.logo} resizeMode="contain" />
          <Text style={styles.headerTitle}>NEAST Merchant</Text>
          <Text style={styles.headerSubtitle}>Log in with your merchant account</Text>
        </GradientHeader>

        <View style={styles.form}>
          <TextField
            label="Email"
            value={account}
            onChangeText={setAccount}
            placeholder="name@example.com"
            keyboardType="email-address"
            autoCapitalize="none"
            autoCorrect={false}
          />
          <TextField
            label="Password"
            value={password}
            onChangeText={setPassword}
            placeholder="Your password"
            secureTextEntry
          />
          <Button
            title="Log In"
            onPress={submit}
            loading={loginMutation.isPending}
            style={styles.submit}
          />
        </View>
      </ScrollView>
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
});
