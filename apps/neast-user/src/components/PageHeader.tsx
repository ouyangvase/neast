import { StyleSheet, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { BrandHeader, userHomeColors } from '@neast/ui-mobile';

/** Centered title and left back control on the navy bar used by tab subpages. */
export function PageHeader({ title }: { title: string }) {
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.bar, { paddingTop: insets.top }]}>
      <BrandHeader
        title={title}
        onBack={() => router.back()}
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
