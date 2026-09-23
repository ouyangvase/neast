import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { Button, coreColors, spacing, textStyles } from '@neast/ui-mobile';

/** Router error builder (not_found_screen parity). */
export default function NotFoundRoute() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Page not found</Text>
      <Text style={styles.message}>The page you are looking for does not exist.</Text>
      <Button title="Back to Home" fullWidth={false} onPress={() => router.replace('/')} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: coreColors.white,
    padding: spacing.xl,
    gap: spacing.md,
  },
  title: {
    ...textStyles.heading2,
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
  },
});
