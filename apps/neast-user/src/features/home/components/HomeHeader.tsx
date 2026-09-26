import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { BellIcon, ScanIcon, Toast, userHomeColors } from '@neast/ui-mobile';

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
