import { useEffect, useRef } from 'react';
import {
  Animated,
  StyleSheet,
  type DimensionValue,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

import { coreColors } from '../tokens/colors';
import { radii } from '../tokens/layout';

export interface SkeletonProps {
  width?: DimensionValue;
  height?: DimensionValue;
  /** Corner radius. Default: 8. */
  radius?: number;
  style?: StyleProp<ViewStyle>;
}

/** Pulsing placeholder block for loading states. */
export function Skeleton({
  width = '100%',
  height = 16,
  radius = radii.button,
  style,
}: SkeletonProps) {
  const opacity = useRef(new Animated.Value(0.55)).current;

  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(opacity, { toValue: 1, duration: 650, useNativeDriver: true }),
        Animated.timing(opacity, { toValue: 0.55, duration: 650, useNativeDriver: true }),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [opacity]);

  return (
    <Animated.View
      style={[styles.block, { width, height, borderRadius: radius, opacity }, style]}
    />
  );
}

const styles = StyleSheet.create({
  block: {
    backgroundColor: coreColors.divider,
  },
});
