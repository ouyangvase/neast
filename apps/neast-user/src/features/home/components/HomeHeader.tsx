import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { BellIcon, ScanIcon, Toast, userHomeColors } from '@neast/ui-mobile';

import logo from '@assets/images/home/hone_logo.png';

import { apiErrorMessage } from '@/lib/api';
import { openScanner } from '@/lib/callbacks';
import { getRentPropertyBySn } from '@/lib/endpoints';

interface HomeHeaderProps {
  /** Greeting name; guests fall back to "there". */
  firstName?: string;
  isLoggedIn: boolean;
  unreadCount: number;
}

/** Home header: brand mark, one-line greeting, bell and scan. */
export function HomeHeader({ firstName, isLoggedIn, unreadCount }: HomeHeaderProps) {
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
      <Image
        source={logo}
        style={styles.logo}
        resizeMode="contain"
        accessibilityLabel="NEAST"
      />
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
              <BellIcon size={32} />
              {isLoggedIn && unreadCount > 0 ? (
                <View style={styles.badge}>
                  <Text style={styles.badgeText}>{unreadCount > 99 ? '99+' : unreadCount}</Text>
                </View>
              ) : null}
            </View>
          </Pressable>
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Scan QR"
            onPress={onScan}
            style={styles.iconButton}
          >
            <ScanIcon size={32} />
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
  logo: {
    width: 36,
    height: 28,
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
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badge: {
    position: 'absolute',
    top: -2,
    right: -6,
    minWidth: 16,
    height: 16,
    borderRadius: 8,
    paddingHorizontal: 4,
    backgroundColor: userHomeColors.badgeRed,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badgeText: {
    color: userHomeColors.surface,
    fontSize: 10,
    fontWeight: '700',
  },
});
