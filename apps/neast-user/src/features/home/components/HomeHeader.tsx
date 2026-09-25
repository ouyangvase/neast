import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Svg, { Circle, Path } from 'react-native-svg';

import { Toast, userHomeColors } from '@neast/ui-mobile';

import { apiErrorMessage } from '../../../lib/api';
import { openScanner } from '../../../lib/callbacks';
import { getRentPropertyBySn } from '../../../lib/endpoints';

interface HomeHeaderProps {
  /** Greeting name; guests fall back to "there". */
  firstName?: string;
  isLoggedIn: boolean;
  hasUnread: boolean;
}

/** Home header: wordmark, one-line greeting, bell and scan. */
export function HomeHeader({ firstName, isLoggedIn, hasUnread }: HomeHeaderProps) {
  const insets = useSafeAreaInsets();
  const name = firstName ?? 'there';

  const onScan = () => {
    if (!isLoggedIn) {
      router.push('/login');
      return;
    }
    openScanner((value) => {
      getRentPropertyBySn(value)
        .then((property) => {
          Toast.success(`Connected to ${property.name}`);
          router.push({
            pathname: '/pay-rent/create/connect',
            params: {
              propertyId: String(property.id),
              propertyName: property.name,
              ownerName: property.landlord_name,
            },
          });
        })
        .catch((error: unknown) => Toast.error(apiErrorMessage(error)));
    });
  };

  return (
    <View style={[styles.header, { paddingTop: insets.top + 8 }]}>
      <Text style={styles.wordmark}>NEAST</Text>
      <View style={styles.brandRow}>
        <Text style={styles.greeting} numberOfLines={1}>
          Hello, {name}
        </Text>
        <View style={styles.actions}>
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Open notifications"
            onPress={() => router.push(isLoggedIn ? '/notification' : '/login')}
            style={styles.iconButton}
          >
            <View>
              <BellIcon />
              {isLoggedIn && hasUnread ? <View style={styles.badge} /> : null}
            </View>
          </Pressable>
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Scan QR"
            onPress={onScan}
            style={styles.iconButton}
          >
            <ScanIcon />
          </Pressable>
        </View>
      </View>
    </View>
  );
}

function BellIcon() {
  return (
    <Svg width={24} height={24} viewBox="0 0 24 24">
      <Circle cx={12} cy={12} r={12} fill="#0851AA" />
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

function ScanIcon() {
  return (
    <Svg width={24} height={24} viewBox="0 0 24 24">
      <Circle cx={12} cy={12} r={12} fill="#0851AA" />
      <Path
        d="M7.2 9.4V8.1c0-.5.4-.9.9-.9h1.3M14.6 7.2h1.3c.5 0 .9.4.9.9v1.3M16.8 14.6v1.3c0 .5-.4.9-.9.9h-1.3M9.4 16.8H8.1c-.5 0-.9-.4-.9-.9v-1.3"
        stroke={userHomeColors.surface}
        strokeWidth={1.4}
        strokeLinecap="round"
        fill="none"
      />
      <Path
        d="M8 12h8"
        stroke={userHomeColors.surface}
        strokeWidth={1.4}
        strokeLinecap="round"
      />
    </Svg>
  );
}

const styles = StyleSheet.create({
  header: {
    backgroundColor: 'transparent',
    paddingHorizontal: 20,
    paddingBottom: 16,
    gap: 8,
  },
  wordmark: {
    color: userHomeColors.surface,
    fontSize: 18,
    fontWeight: '800',
    letterSpacing: 1,
  },
  brandRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  greeting: {
    flex: 1,
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  actions: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  iconButton: {
    width: 40,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badge: {
    position: 'absolute',
    top: 0,
    right: 0,
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: userHomeColors.badgeRed,
  },
});
