import { useEffect, useRef } from 'react';
import { Animated, Easing, StyleSheet, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import Svg, { Circle, Path } from 'react-native-svg';

import { coreColors, userHomeColors } from '@ui/tokens/colors';

interface IconProps {
  size?: number;
  color?: string;
}

/** Official WhatsApp mark (`Ionicons` `logo-whatsapp`). Brand green by default. */
export function WhatsAppIcon({ size = 20, color = '#25D366' }: IconProps) {
  return <Ionicons name="logo-whatsapp" size={size} color={color} />;
}

export function MailIcon({ size = 20, color }: IconProps) {
  return <Ionicons name="mail-outline" size={size} color={color} />;
}

export function QrCodeIcon({ size = 24, color }: IconProps) {
  return <Ionicons name="qr-code-outline" size={size} color={color} />;
}

export function EditIcon({ size = 24, color }: IconProps) {
  return <Ionicons name="create-outline" size={size} color={color} />;
}

export function DocumentIcon({ size = 24, color }: IconProps) {
  return <Ionicons name="document-attach-outline" size={size} color={color} />;
}

export function UploadIcon({ size = 24, color }: IconProps) {
  return <Ionicons name="cloud-upload-outline" size={size} color={color} />;
}

export function BellIcon({ size = 24 }: { size?: number }) {
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24">
      <Circle cx={12} cy={12} r={12} fill={coreColors.brandBlue} />
      <Path
        d="M12 6.2a3.2 3.2 0 0 0-3.2 3.2v1.5c0 .5-.2 1-.5 1.4l-.7.8c-.4.4-.1 1.1.5 1.1h7.8c.6 0 .9-.7.5-1.1l-.7-.8c-.3-.4-.5-.9-.5-1.4V9.4A3.2 3.2 0 0 0 12 6.2Z"
        fill={userHomeColors.surface}
      />
      <Path
        d="M10.6 15.6a1.4 1.4 0 0 0 2.8 0"
        stroke={userHomeColors.surface}
        strokeWidth={1.2}
        strokeLinecap="round"
        fill="none"
      />
    </Svg>
  );
}

/** Soft green disc with a filled check, for a completed payment. */
export function SuccessMark({ size = 112 }: { size?: number }) {
  const inner = size * (72 / 112);
  const icon = size * (40 / 112);
  const disc = useRef(new Animated.Value(0)).current;
  const tick = useRef(new Animated.Value(0)).current;
  const pulse = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    const entrance = Animated.sequence([
      Animated.timing(disc, {
        toValue: 1,
        duration: 280,
        easing: Easing.out(Easing.back(1.2)),
        useNativeDriver: true,
      }),
      Animated.timing(tick, {
        toValue: 1,
        duration: 160,
        easing: Easing.out(Easing.cubic),
        useNativeDriver: true,
      }),
    ]);
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(pulse, {
          toValue: 1.08,
          duration: 700,
          easing: Easing.inOut(Easing.ease),
          useNativeDriver: true,
        }),
        Animated.timing(pulse, {
          toValue: 1,
          duration: 700,
          easing: Easing.inOut(Easing.ease),
          useNativeDriver: true,
        }),
      ]),
    );
    entrance.start();
    loop.start();
    return () => {
      entrance.stop();
      loop.stop();
    };
  }, [disc, pulse, tick]);

  return (
    <Animated.View style={{ transform: [{ scale: pulse }] }}>
      <Animated.View
        style={[
          styles.successOuter,
          { width: size, height: size, borderRadius: size / 2, transform: [{ scale: disc }] },
        ]}
      >
        <View
          style={[
            styles.successInner,
            { width: inner, height: inner, borderRadius: inner / 2 },
          ]}
        >
          <Animated.View style={{ opacity: tick, transform: [{ scale: tick }] }}>
            <Ionicons name="checkmark" size={icon} color={coreColors.white} />
          </Animated.View>
        </View>
      </Animated.View>
    </Animated.View>
  );
}

export function ScanIcon({ size = 24 }: { size?: number }) {
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24">
      <Circle cx={12} cy={12} r={12} fill={coreColors.brandBlue} />
      <Path
        d="M7.2 9.4V8.1c0-.5.4-.9.9-.9h1.3M14.6 7.2h1.3c.5 0 .9.4.9.9v1.3M16.8 14.6v1.3c0 .5-.4.9-.9.9h-1.3M9.4 16.8H8.1c-.5 0-.9-.4-.9-.9v-1.3"
        stroke={userHomeColors.surface}
        strokeWidth={1.4}
        strokeLinecap="round"
        fill="none"
      />
      <Path d="M8 12h8" stroke={userHomeColors.surface} strokeWidth={1.4} strokeLinecap="round" />
    </Svg>
  );
}

const styles = StyleSheet.create({
  successOuter: {
    width: 112,
    height: 112,
    borderRadius: 56,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: coreColors.tintGreen,
  },
  successInner: {
    width: 72,
    height: 72,
    borderRadius: 36,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: coreColors.darkGreen,
  },
});
