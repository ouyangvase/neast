import { useEffect } from 'react';
import { Image, Platform, StyleSheet, View } from 'react-native';
import * as SplashScreen from 'expo-splash-screen';

import { useSessionStatus } from '@neast/types';
import { coreColors } from '@neast/ui-mobile';

import launchIos from '@assets/images/launch_ios.png';
import launchAndroid from '@assets/images/launch_android.png';

import { navigateAfterSplash } from '@/lib/auth';

/**
 * Splash (splash_screen parity): mirrors the native splash, waits 1500ms
 * after the session is hydrated, then routes via navigateAfterSplash.
 */
export default function SplashRoute() {
  const sessionStatus = useSessionStatus();

  useEffect(() => {
    if (sessionStatus !== 'ready') {
      return;
    }
    void SplashScreen.hideAsync();
    const timer = setTimeout(() => navigateAfterSplash(), 1500);
    return () => clearTimeout(timer);
  }, [sessionStatus]);

  return (
    <View style={[styles.container, Platform.OS === 'ios' ? styles.iosBg : styles.androidBg]}>
      <Image
        source={Platform.OS === 'ios' ? launchIos : launchAndroid}
        style={Platform.OS === 'ios' ? styles.imageCover : styles.imageCentered}
        resizeMode={Platform.OS === 'ios' ? 'cover' : 'contain'}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  iosBg: {
    backgroundColor: coreColors.splashBlue,
  },
  androidBg: {
    backgroundColor: coreColors.white,
  },
  imageCover: {
    width: '100%',
    height: '100%',
  },
  imageCentered: {
    width: 220,
    height: 220,
  },
});
