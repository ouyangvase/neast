import QRCode from 'react-native-qrcode-svg';
import { StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';
import type { ImageSourcePropType } from 'react-native';

import { coreColors } from '@ui/tokens/colors';

export interface QrCodeViewProps {
  /** Payload. User identity QR = backend `qrCode` string; property QR = raw `sn`. */
  value: string;
  size?: number;
  color?: string;
  backgroundColor?: string;
  /** Center logo overlay. */
  logo?: ImageSourcePropType;
  logoSize?: number;
  style?: StyleProp<ViewStyle>;
}

/** QR code display (qr_flutter `QrImageView` equivalent). */
export function QrCodeView({
  value,
  size = 220,
  color = coreColors.blackText,
  backgroundColor = coreColors.white,
  logo,
  logoSize,
  style,
}: QrCodeViewProps) {
  return (
    <View style={[styles.container, { backgroundColor }, style]}>
      <QRCode
        value={value}
        size={size}
        color={color}
        backgroundColor={backgroundColor}
        logo={logo}
        logoSize={logoSize}
        ecl="M"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
});
