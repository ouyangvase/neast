import { StyleSheet, Text, View, type StyleProp, type ViewStyle } from 'react-native';

import { merchantAccentColors } from '@ui/tokens/colors';
import { radii } from '@ui/tokens/layout';

export interface BetaTagProps {
  label?: string;
  style?: StyleProp<ViewStyle>;
}

/** Small "Beta" badge (Flutter `beta_tag.dart` overlay). */
export function BetaTag({ label = 'Beta', style }: BetaTagProps) {
  return (
    <View style={[styles.tag, style]}>
      <Text style={styles.text}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  tag: {
    backgroundColor: merchantAccentColors.goldBright,
    borderRadius: radii.pill,
    paddingHorizontal: 6,
    paddingVertical: 1,
    alignSelf: 'flex-start',
  },
  text: {
    fontSize: 8,
    fontWeight: '700',
    color: '#0F172A',
  },
});
