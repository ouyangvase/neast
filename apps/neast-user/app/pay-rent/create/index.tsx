import type { ReactNode } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import {
  Card,
  Chevron,
  EditIcon,
  QrCodeIcon,
  spacing,
  textStyles,
  userHomeColors,
} from '@neast/ui-mobile';

import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

/** First step: choose connect-with-owner or enter the tenancy manually. */
export default function AddTenancyChoiceRoute() {
  return (
    <Screen edges={[]}>
      <PageHeader title="Add Tenancy" />
      <View style={styles.body}>
        <Text style={styles.heading}>How do you want to add this tenancy?</Text>
        <ChoiceRow
          title="Scan owner QR"
          subtitle="Link a property already on NEAST"
          icon={<QrCodeIcon size={22} color={userHomeColors.navy} />}
          onPress={() => router.push('/pay-rent/create/connect')}
        />
        <ChoiceRow
          title="Enter details"
          subtitle="For an owner who is not on NEAST yet"
          icon={<EditIcon size={22} color={userHomeColors.navy} />}
          onPress={() => router.push('/pay-rent/create/manual')}
        />
      </View>
    </Screen>
  );
}

function ChoiceRow({
  title,
  subtitle,
  icon,
  onPress,
}: {
  title: string;
  subtitle: string;
  icon: ReactNode;
  onPress: () => void;
}) {
  return (
    <Card style={styles.row} onPress={onPress}>
      <View style={styles.iconWell}>{icon}</View>
      <View style={styles.copy}>
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.subtitle}>{subtitle}</Text>
      </View>
      <Chevron direction="right" color={userHomeColors.textSecondary} size={8} />
    </Card>
  );
}

const styles = StyleSheet.create({
  body: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
    gap: spacing.md,
  },
  heading: {
    ...textStyles.body,
    color: userHomeColors.textSecondary,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  iconWell: {
    width: 44,
    height: 44,
    borderRadius: 12,
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  copy: {
    flex: 1,
    gap: 2,
  },
  title: {
    ...textStyles.body,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  subtitle: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
  },
});
