import type { ReactNode } from 'react';
import { StyleSheet, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { userHomeColors } from '@ui/tokens/colors';
import { BrandHeader } from './BrandHeader';

export interface PageHeaderProps {
  title: string;
  onBack?: () => void;
  showBack?: boolean;
  right?: ReactNode;
}

/** Centered title and left back control on the navy bar used by tab subpages. */
export function PageHeader({ title, onBack, showBack = true, right }: PageHeaderProps) {
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.bar, { paddingTop: insets.top }]}>
      <BrandHeader
        title={title}
        onBack={showBack ? (onBack ?? (() => router.back())) : undefined}
        right={right}
        backgroundColor={userHomeColors.navy}
        chevronColor={userHomeColors.surface}
        titleStyle={styles.title}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    backgroundColor: userHomeColors.navy,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 18,
    fontWeight: '700',
  },
});
