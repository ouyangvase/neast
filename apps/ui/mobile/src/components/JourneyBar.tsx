import { useEffect, useRef } from 'react';
import { Animated, StyleSheet, Text, View } from 'react-native';

import { SuccessMark } from './icons';
import { coreColors, userHomeColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

/** Step labels with the current index. The connector fills when the index changes. */
export function JourneyBar({ steps, activeIndex }: { steps: string[]; activeIndex: number }) {
  const span = Math.max(steps.length - 1, 1);
  const progress = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(progress, {
      toValue: Math.min(Math.max(activeIndex, 0), span) / span,
      duration: 280,
      useNativeDriver: false,
    }).start();
  }, [activeIndex, progress, span]);

  const fillWidth = progress.interpolate({
    inputRange: [0, 1],
    outputRange: ['0%', `${(span / steps.length) * 100}%`],
  });

  return (
    <View
      accessibilityRole="progressbar"
      accessibilityValue={{ min: 1, max: steps.length, now: activeIndex + 1 }}
      style={styles.bar}
    >
      <View style={styles.rail}>
        <View style={[styles.track, { left: `${50 / steps.length}%`, right: `${50 / steps.length}%` }]} />
        <Animated.View style={[styles.trackFill, { left: `${50 / steps.length}%`, width: fillWidth }]} />
        <View style={styles.nodes}>
          {steps.map((label, index) => {
            const reached = index <= activeIndex;
            const current = index === activeIndex;
            return (
              <View key={label} style={styles.node}>
                {index < activeIndex ? (
                  <SuccessMark size={28} />
                ) : (
                  <View style={[styles.dot, reached && styles.dotReached, current && styles.dotCurrent]}>
                    <Text style={[styles.dotText, reached && styles.dotTextReached]}>{index + 1}</Text>
                  </View>
                )}
              </View>
            );
          })}
        </View>
      </View>
      <View style={styles.labels}>
        {steps.map((label, index) => (
          <Text
            key={label}
            numberOfLines={1}
            style={[styles.label, index === activeIndex && styles.labelCurrent]}
          >
            {label}
          </Text>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    backgroundColor: coreColors.white,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    paddingBottom: spacing.sm,
  },
  rail: {
    height: 28,
    justifyContent: 'center',
  },
  track: {
    position: 'absolute',
    top: 13,
    height: 2,
    backgroundColor: coreColors.borderLight,
  },
  trackFill: {
    position: 'absolute',
    top: 13,
    height: 2,
    backgroundColor: userHomeColors.navy,
  },
  nodes: {
    flexDirection: 'row',
  },
  node: {
    flex: 1,
    alignItems: 'center',
  },
  dot: {
    width: 28,
    height: 28,
    borderRadius: 14,
    borderWidth: 2,
    borderColor: coreColors.border,
    backgroundColor: coreColors.white,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dotReached: {
    borderColor: userHomeColors.navy,
    backgroundColor: userHomeColors.navy,
  },
  dotCurrent: {
    borderColor: userHomeColors.navy,
  },
  dotText: {
    ...textStyles.caption,
    fontWeight: '700',
    color: coreColors.textHint,
  },
  dotTextReached: {
    color: coreColors.white,
  },
  labels: {
    flexDirection: 'row',
    marginTop: spacing.xs,
  },
  label: {
    flex: 1,
    textAlign: 'center',
    ...textStyles.caption,
  },
  labelCurrent: {
    color: userHomeColors.navy,
    fontWeight: '700',
  },
});
