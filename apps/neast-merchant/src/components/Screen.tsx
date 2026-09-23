import { StyleSheet, View } from 'react-native';
import { SafeAreaView, type Edge } from 'react-native-safe-area-context';
import type { ReactNode } from 'react';

import { coreColors } from '@neast/ui-mobile';

interface ScreenProps {
  children: ReactNode;
  /** Defaults to ['top']. Pass `edges={[]}` when a header handles the inset. */
  edges?: Edge[];
}

/** App screen scaffold: white background + safe-area padding. */
export function Screen({ children, edges = ['top'] }: ScreenProps) {
  return (
    <SafeAreaView style={styles.base} edges={edges}>
      <View style={styles.flex}>{children}</View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  base: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  flex: {
    flex: 1,
  },
});
