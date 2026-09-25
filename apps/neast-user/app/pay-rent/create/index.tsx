import { StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';

import { Card, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';

/** First step: choose connect-with-owner or enter the tenancy manually. */
export default function AddTenancyChoiceRoute() {
  return (
    <Screen edges={[]}>
      <PageHeader title="Add Tenancy" />
      <View style={styles.center}>
        <ChoiceCard
          title="Connect with owner"
          subtitle="Scan the owner's QR code"
          icon="qr-code-outline"
          onPress={() => router.push('/pay-rent/create/connect')}
        />
        <ChoiceCard
          title="Add manually"
          subtitle="Enter the property and owner yourself"
          icon="create-outline"
          onPress={() => router.push('/pay-rent/create/manual')}
        />
      </View>
    </Screen>
  );
}

function ChoiceCard({
  title,
  subtitle,
  icon,
  onPress,
}: {
  title: string;
  subtitle: string;
  icon: 'qr-code-outline' | 'create-outline';
  onPress: () => void;
}) {
  return (
    <Card style={styles.card} onPress={onPress}>
      <Ionicons name={icon} size={40} color={coreColors.brandBlue} />
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.subtitle}>{subtitle}</Text>
    </Card>
  );
}

const styles = StyleSheet.create({
  center: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: spacing.xl,
    gap: spacing.lg,
  },
  card: {
    alignItems: 'center',
    gap: spacing.sm,
    paddingVertical: spacing.xxl,
  },
  title: {
    ...textStyles.heading3,
    textAlign: 'center',
  },
  subtitle: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
  },
});
