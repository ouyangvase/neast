import { useCallback, useEffect, useRef } from 'react';
import { BackHandler, Image, Platform, StyleSheet, View } from 'react-native';
import { useFocusEffect } from 'expo-router';

import { useIsLoggedIn } from '@neast/types';
import { coreColors, TabBar, Toast, type TabBarItem } from '@neast/ui-mobile';

import scanIcon from '@assets/images/main/scan.png';
import scanActiveIcon from '@assets/images/main/scan-act.png';
import givePointsIcon from '@assets/images/main/give-points.png';
import givePointsActiveIcon from '@assets/images/main/give-points-act.png';
import settlementIcon from '@assets/images/main/settlement.png';
import settlementActiveIcon from '@assets/images/main/settlement-act.png';
import accountIcon from '@assets/images/main/account.png';
import accountActiveIcon from '@assets/images/main/account-act.png';

import { initPushNotifications } from '@/lib/push';
import { useTabsStore, type MainTab } from '@/stores/tabs';
import { AccountTab } from '@/features/account/AccountTab';
import { GivePointsTab } from '@/features/give-points/GivePointsTab';
import { ScanTab } from '@/features/scan/ScanTab';
import { SettlementTab } from '@/features/settlement/SettlementTab';

const tabIconStyle = { width: 24, height: 24 } as const;

const TAB_ITEMS: TabBarItem[] = [
  {
    key: 'scan',
    label: 'Scan',
    icon: <Image source={scanIcon} style={tabIconStyle} />,
    activeIcon: <Image source={scanActiveIcon} style={tabIconStyle} />,
  },
  {
    key: 'givePoints',
    label: 'Give Points',
    icon: <Image source={givePointsIcon} style={tabIconStyle} />,
    activeIcon: <Image source={givePointsActiveIcon} style={tabIconStyle} />,
  },
  {
    key: 'settlement',
    label: 'Settlement',
    icon: <Image source={settlementIcon} style={tabIconStyle} />,
    activeIcon: <Image source={settlementActiveIcon} style={tabIconStyle} />,
  },
  {
    key: 'account',
    label: 'Account',
    icon: <Image source={accountIcon} style={tabIconStyle} />,
    activeIcon: <Image source={accountActiveIcon} style={tabIconStyle} />,
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
        {tab === 'scan' ? <ScanTab /> : null}
        {tab === 'givePoints' ? <GivePointsTab /> : null}
        {tab === 'settlement' ? <SettlementTab /> : null}
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
