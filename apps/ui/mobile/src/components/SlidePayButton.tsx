import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Animated, PanResponder, StyleSheet, Text, View } from 'react-native';

import { userHomeColors } from '@ui/tokens/colors';
import { Chevron } from './Chevron';

export function SlidePayButton({
  title,
  bottom,
  disabled,
  loading,
  onConfirm,
}: {
  title: string;
  bottom: number;
  disabled: boolean;
  loading: boolean;
  onConfirm: () => boolean;
}) {
  const trackWidth = useRef(0);
  const drag = useRef(0);
  const thumb = useRef(new Animated.Value(0)).current;
  const coverWidth = useRef(Animated.add(thumb, 46)).current;
  const [confirming, setConfirming] = useState(false);
  const disabledRef = useRef(disabled);
  const loadingRef = useRef(loading);
  const onConfirmRef = useRef(onConfirm);
  disabledRef.current = disabled;
  loadingRef.current = loading;
  onConfirmRef.current = onConfirm;

  useEffect(() => {
    if (loading) return;
    setConfirming(false);
    drag.current = 0;
    Animated.spring(thumb, { toValue: 0, useNativeDriver: false, bounciness: 0 }).start();
  }, [loading, thumb]);

  const pan = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => !disabledRef.current && !loadingRef.current,
      onStartShouldSetPanResponderCapture: () => !disabledRef.current && !loadingRef.current,
      onMoveShouldSetPanResponder: (_, gesture) =>
        !disabledRef.current &&
        !loadingRef.current &&
        Math.abs(gesture.dx) > Math.abs(gesture.dy),
      onMoveShouldSetPanResponderCapture: (_, gesture) =>
        !disabledRef.current &&
        !loadingRef.current &&
        Math.abs(gesture.dx) > Math.abs(gesture.dy),
      onPanResponderTerminationRequest: () => false,
      onShouldBlockNativeResponder: () => true,
      onPanResponderGrant: () => {
        setConfirming(true);
      },
      onPanResponderMove: (_, gesture) => {
        const max = Math.max(trackWidth.current - 50, 0);
        const next = Math.min(Math.max(gesture.dx, 0), max);
        drag.current = next;
        thumb.setValue(next);
      },
      onPanResponderRelease: () => {
        const max = Math.max(trackWidth.current - 50, 0);
        if (max > 0 && drag.current >= max - 12) {
          thumb.setValue(max);
          drag.current = max;
          if (!onConfirmRef.current()) {
            setConfirming(false);
            drag.current = 0;
            Animated.spring(thumb, { toValue: 0, useNativeDriver: false, bounciness: 0 }).start();
          }
          return;
        }
        setConfirming(false);
        drag.current = 0;
        Animated.spring(thumb, { toValue: 0, useNativeDriver: false, bounciness: 0 }).start();
      },
      onPanResponderTerminate: () => {
        setConfirming(false);
        drag.current = 0;
        Animated.spring(thumb, { toValue: 0, useNativeDriver: false, bounciness: 0 }).start();
      },
    }),
  ).current;

  return (
    <View
      accessibilityRole="adjustable"
      accessibilityLabel={confirming ? 'Confirming payment..' : title}
      style={[styles.payButton, { bottom }, disabled && styles.payDisabled]}
      onLayout={(event) => {
        trackWidth.current = event.nativeEvent.layout.width;
      }}
    >
      {confirming ? null : (
        <Text style={styles.payText} numberOfLines={1}>
          {title}
        </Text>
      )}
      {/* Track color, so text the handle has passed stays covered. */}
      <Animated.View pointerEvents="none" style={[styles.cover, { width: coverWidth }]} />
      {confirming ? (
        <Text pointerEvents="none" style={[styles.payText, styles.confirmingText]} numberOfLines={1}>
          Confirming payment..
        </Text>
      ) : null}
      <Animated.View style={[styles.thumb, { transform: [{ translateX: thumb }] }]} {...pan.panHandlers}>
        {loading ? (
          <ActivityIndicator color={userHomeColors.navy} />
        ) : (
          <View pointerEvents="none" style={styles.thumbArrow}>
            <Chevron direction="right" color={userHomeColors.navy} size={10} />
          </View>
        )}
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  payButton: {
    position: 'absolute',
    left: 14,
    right: 14,
    zIndex: 2,
    height: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  payDisabled: {
    opacity: 0.5,
  },
  payText: {
    alignSelf: 'stretch',
    textAlign: 'center',
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  confirmingText: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: 0,
    height: 46,
    lineHeight: 46,
  },
  cover: {
    position: 'absolute',
    left: 0,
    top: 0,
    bottom: 0,
    backgroundColor: userHomeColors.navy,
  },
  thumb: {
    position: 'absolute',
    left: 4,
    top: 4,
    width: 42,
    height: 38,
    borderRadius: 8,
    backgroundColor: userHomeColors.surface,
    alignItems: 'center',
    justifyContent: 'center',
  },
  thumbArrow: {
    // Chevron draws the right and bottom edges, then rotates. That ink sits
    // about 2.5px to the right of the box, so the arrow looks off-center.
    transform: [{ translateX: -2.5 }],
  },
});
