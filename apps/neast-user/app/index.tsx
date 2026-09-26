import { useCallback, useEffect, useRef } from 'react';
import { BackHandler, Platform, StyleSheet, View } from 'react-native';
import { router, useFocusEffect } from 'expo-router';

import { useIsLoggedIn } from '@neast/types';
import { coreColors, TabBar, Toast, type TabBarItem } from '@neast/ui-mobile';

import HomeIcon from '@assets/images/main/home.svg';
import HomeActiveIcon from '@assets/images/main/home-act.svg';
import PayRentIcon from '@assets/images/main/pay-rent.svg';
import PayRentActiveIcon from '@assets/images/main/pay-rent-act.svg';
import RewardIcon from '@assets/images/main/reward.svg';
import RewardActiveIcon from '@assets/images/main/reward-act.svg';
import AccountIcon from '@assets/images/main/account.svg';
import AccountActiveIcon from '@assets/images/main/account-act.svg';

import { initPushNotifications } from '@/lib/push';
import { drainPendingRoute } from '@/stores/pending-route';
import { useTabsStore, type MainTab } from '@/stores/tabs';
import { AccountTab } from '@/features/account/AccountTab';
import { HomeTab } from '@/features/home/HomeTab';
import { PayRentTab } from '@/features/pay-rent/PayRentTab';
import { RewardTab } from '@/features/reward/RewardTab';

const TAB_ITEMS: TabBarItem[] = [
  {
    key: 'home',
    label: 'Home',
    icon: <HomeIcon width={28} height={28} />,
    activeIcon: <HomeActiveIcon width={28} height={28} />,
  },
  {
    key: 'payRent',
    label: 'Pay rent',
    icon: <PayRentIcon width={28} height={28} />,
    activeIcon: <PayRentActiveIcon width={28} height={28} />,
  },
  {
    key: 'reward',
    label: 'Reward',
    icon: <RewardIcon width={28} height={28} />,
    activeIcon: <RewardActiveIcon width={28} height={28} />,
  },
  {
    key: 'account',
    label: 'Account',
    icon: <AccountIcon width={28} height={28} />,
    activeIcon: <AccountActiveIcon width={28} height={28} />,
  },
];

/** MainScreen parity: 4-tab shell (IndexedStack → conditional render + query cache). */
export default function MainRoute() {
  const tab = useTabsStore((state) => state.tab);
  const select = useTabsStore((state) => state.select);
  const isLoggedIn = useIsLoggedIn();

  // Push notifications initialize post-frame when logged in.
  useEffect(() => {
    if (isLoggedIn) {
      void initPushNotifications();
    }
  }, [isLoggedIn]);

  // flushPendingDeepLinkOnMain parity: replay a stashed deep link once on the shell.
  useEffect(() => {
    if (!isLoggedIn) {
      return;
    }
    const pending = drainPendingRoute();
    if (pending) {
      const timer = setTimeout(() => router.push(pending), 80);
      return () => clearTimeout(timer);
    }
  }, [isLoggedIn]);

  // Double-back-to-exit (2s window), only while the shell is focused.
  const lastBackPress = useRef(0);
  useFocusEffect(
    useCallback(() => {
      if (Platform.OS !== 'android') {
        return;
      }
      const subscription = BackHandler.addEventListener('hardwareBackPress', () => {
        const now = Date.now();
        if (now - lastBackPress.current < 2000) {
          return false; // exit the app
        }
        lastBackPress.current = now;
        Toast.show('Press back again to exit');
        return true;
      });
      return () => subscription.remove();
    }, []),
  );

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        {tab === 'home' ? <HomeTab /> : null}
        {tab === 'payRent' ? <PayRentTab /> : null}
        {tab === 'reward' ? <RewardTab /> : null}
        {tab === 'account' ? <AccountTab /> : null}
      </View>
      <TabBar items={TAB_ITEMS} activeKey={tab} onChange={(key) => select(key as MainTab)} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  content: {
    flex: 1,
  },
});
