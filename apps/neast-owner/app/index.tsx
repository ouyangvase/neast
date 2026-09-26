import { useCallback, useEffect, useRef } from 'react';
import { BackHandler, Platform, StyleSheet, View } from 'react-native';
import { useFocusEffect } from 'expo-router';

import { useIsLoggedIn } from '@neast/types';
import { coreColors, TabBar, Toast, type TabBarItem } from '@neast/ui-mobile';

import HomeIcon from '@assets/images/main/home.svg';
import HomeActiveIcon from '@assets/images/main/home-act.svg';
import PropertiesIcon from '@assets/images/main/properties.svg';
import PropertiesActiveIcon from '@assets/images/main/properties-act.svg';
import RecordsIcon from '@assets/images/main/records.svg';
import RecordsActiveIcon from '@assets/images/main/records-act.svg';
import AccountIcon from '@assets/images/main/account.svg';
import AccountActiveIcon from '@assets/images/main/account-act.svg';

import { initPushNotifications } from '@/lib/push';
import { useTabsStore, type MainTab } from '@/stores/tabs';
import { AccountTab } from '@/features/account/AccountTab';
import { HomeTab } from '@/features/home/HomeTab';
import { PropertiesTab } from '@/features/properties/PropertiesTab';
import { RecordsTab } from '@/features/records/RecordsTab';

const TAB_ITEMS: TabBarItem[] = [
  {
    key: 'home',
    label: 'Home',
    icon: <HomeIcon width={24} height={24} />,
    activeIcon: <HomeActiveIcon width={24} height={24} />,
  },
  {
    key: 'properties',
    label: 'Properties',
    icon: <PropertiesIcon width={24} height={24} />,
    activeIcon: <PropertiesActiveIcon width={24} height={24} />,
  },
  {
    key: 'records',
    label: 'Records',
    icon: <RecordsIcon width={24} height={24} />,
    activeIcon: <RecordsActiveIcon width={24} height={24} />,
  },
  {
    key: 'account',
    label: 'Account',
    icon: <AccountIcon width={24} height={24} />,
    activeIcon: <AccountActiveIcon width={24} height={24} />,
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
        {tab === 'properties' ? <PropertiesTab /> : null}
        {tab === 'records' ? <RecordsTab /> : null}
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
