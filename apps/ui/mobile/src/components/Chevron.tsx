import { StyleSheet, View } from 'react-native';

import { coreColors } from '@ui/tokens/colors';

export interface ChevronProps {
  direction?: 'left' | 'right' | 'down' | 'up';
  color?: string;
  size?: number;
}

const ROTATIONS = {
  right: '-45deg',
  down: '45deg',
  left: '135deg',
  up: '-135deg',
} as const;

/** Border-drawn chevron (no icon-font dependency). Internal building block. */
export function Chevron({
  direction = 'left',
  color = coreColors.blackText,
  size = 10,
}: ChevronProps) {
  return (
    <View
      style={[
        styles.chevron,
        {
          width: size,
          height: size,
          borderColor: color,
          transform: [{ rotate: ROTATIONS[direction] }],
        },
      ]}
    />
  );
}

const styles = StyleSheet.create({
  chevron: {
    borderRightWidth: 2,
    borderBottomWidth: 2,
  },
});
