import { useEffect, useRef, useState } from 'react';
import { Animated, StyleSheet, Text, View } from 'react-native';

import { coreColors } from '../tokens/colors';
import { radii, spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';

export type ToastType = 'info' | 'success' | 'error' | 'warning';

export interface ToastOptions {
  type?: ToastType;
  /** Auto-dismiss delay. Default: 2000ms. */
  durationMs?: number;
}

/** Global 1.5s debounce, matching the Flutter apps' ToastUtil. */
const DEBOUNCE_MS = 1500;

type ToastListener = (message: string, options: ToastOptions) => void;

let listener: ToastListener | null = null;
let lastShownAt = 0;

function emit(message: string, options: ToastOptions) {
  const now = Date.now();
  if (now - lastShownAt < DEBOUNCE_MS) return;
  lastShownAt = now;
  listener?.(message, options);
}

/**
 * Imperative toast API (fluttertoast equivalent). Mount `<ToastHost />` once
 * near the app root, then call `Toast.success('…')` from anywhere.
 */
export const Toast = {
  show(message: string, options?: ToastOptions) {
    emit(message, options ?? {});
  },
  info(message: string, options?: Omit<ToastOptions, 'type'>) {
    emit(message, { ...options, type: 'info' });
  },
  success(message: string, options?: Omit<ToastOptions, 'type'>) {
    emit(message, { ...options, type: 'success' });
  },
  error(message: string, options?: Omit<ToastOptions, 'type'>) {
    emit(message, { ...options, type: 'error' });
  },
  warning(message: string, options?: Omit<ToastOptions, 'type'>) {
    emit(message, { ...options, type: 'warning' });
  },
};

const DOT_COLORS: Record<ToastType, string> = {
  info: coreColors.brandBlueLight,
  success: coreColors.darkGreen,
  error: coreColors.error,
  warning: '#F5C842',
};

interface ToastState {
  message: string;
  type: ToastType;
  durationMs: number;
  key: number;
}

/** Renders the current toast. Mount once, above app content. */
export function ToastHost() {
  const [toast, setToast] = useState<ToastState | null>(null);
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    listener = (message, options) => {
      setToast({
        message,
        type: options.type ?? 'info',
        durationMs: options.durationMs ?? 2000,
        key: Date.now(),
      });
    };
    return () => {
      listener = null;
    };
  }, []);

  useEffect(() => {
    if (!toast) return;
    opacity.setValue(0);
    Animated.timing(opacity, { toValue: 1, duration: 150, useNativeDriver: true }).start();
    const hide = setTimeout(() => {
      Animated.timing(opacity, { toValue: 0, duration: 200, useNativeDriver: true }).start(() =>
        setToast(null),
      );
    }, toast.durationMs);
    return () => clearTimeout(hide);
  }, [toast, opacity]);

  if (!toast) return null;

  return (
    <View style={styles.container} pointerEvents="none">
      <Animated.View style={[styles.toast, { opacity }]}>
        <View style={[styles.dot, { backgroundColor: DOT_COLORS[toast.type] }]} />
        <Text style={styles.message}>{toast.message}</Text>
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  toast: {
    flexDirection: 'row',
    alignItems: 'center',
    maxWidth: '80%',
    backgroundColor: 'rgba(15, 23, 42, 0.92)',
    borderRadius: radii.button,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    gap: spacing.sm,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    flexShrink: 1,
  },
});
