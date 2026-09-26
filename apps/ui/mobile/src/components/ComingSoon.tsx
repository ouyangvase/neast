import { StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { userHomeColors } from '@ui/tokens/colors';
import { BrandHeader } from './BrandHeader';

export interface ComingSoonProps {
  /** Screen title in the brand header. */
  title: string;
  /** Supporting line under the "Coming soon" label. */
  message: string;
  onBack?: () => void;
}

/** Shared placeholder for a feature that is not available yet. */
export function ComingSoon({ title, message, onBack }: ComingSoonProps) {
  return (
    <SafeAreaView style={styles.screen} edges={['top']}>
      <BrandHeader
        title={title}
        onBack={onBack}
        backgroundColor={userHomeColors.navy}
        chevronColor={userHomeColors.textOnNavy}
        titleStyle={styles.headerTitle}
      />
      <View style={styles.body}>
        <View style={styles.pill}>
          <Text style={styles.pillText}>Coming soon</Text>
        </View>
        <Text style={styles.message}>{message}</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: userHomeColors.navy,
  },
  headerTitle: {
    color: userHomeColors.surface,
  },
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
    paddingHorizontal: 28,
    paddingTop: 48,
    alignItems: 'center',
  },
  pill: {
    backgroundColor: userHomeColors.cream,
    borderRadius: 999,
    paddingHorizontal: 14,
    paddingVertical: 6,
  },
  pillText: {
    color: userHomeColors.navy,
    fontSize: 13,
    fontWeight: '700',
  },
  message: {
    marginTop: 16,
    color: userHomeColors.textPrimary,
    fontSize: 18,
    lineHeight: 26,
    fontWeight: '600',
    textAlign: 'center',
  },
});
