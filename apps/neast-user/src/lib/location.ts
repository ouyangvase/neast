import * as Location from 'expo-location';
import { useQuery } from '@tanstack/react-query';

export interface Coords {
  latitude: number;
  longitude: number;
}

/** Debug parity with the Flutter apps: kDebugMode hardcodes Bukit Indah, Johor Bahru. */
const DEBUG_COORDS: Coords = { latitude: 1.4862, longitude: 103.6565 };

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export class LocationUnavailableError extends Error {
  constructor(message = 'Location unavailable') {
    super(message);
    this.name = 'LocationUnavailableError';
  }
}

/**
 * location_service.dart parity: service check → permission → last-known →
 * low-accuracy fix with an 8s timeout. Debug builds return the JB hardcode.
 */
export async function getCurrentPosition(): Promise<Coords> {
  if (__DEV__) {
    return DEBUG_COORDS;
  }
  const servicesEnabled = await Location.hasServicesEnabledAsync();
  if (!servicesEnabled) {
    throw new LocationUnavailableError('Location services are disabled');
  }
  const { status } = await Location.requestForegroundPermissionsAsync();
  if (status !== 'granted') {
    throw new LocationUnavailableError('Location permission denied');
  }
  const lastKnown = await Location.getLastKnownPositionAsync();
  if (lastKnown) {
    return { latitude: lastKnown.coords.latitude, longitude: lastKnown.coords.longitude };
  }
  try {
    // expo-location has no timeout option — race an 8s timer instead.
    const position = await Promise.race([
      Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Low }),
      sleep(8000).then(() => {
        throw new LocationUnavailableError('Location fix timed out');
      }),
    ]);
    return { latitude: position.coords.latitude, longitude: position.coords.longitude };
  } catch (error) {
    if (error instanceof LocationUnavailableError) {
      throw error;
    }
    throw new LocationUnavailableError(error instanceof Error ? error.message : undefined);
  }
}

/** Shared device-location query (currentLocationProvider equivalent). Never throws to the UI. */
export function useDeviceLocation() {
  const query = useQuery({
    queryKey: ['device-location'],
    queryFn: getCurrentPosition,
    staleTime: 5 * 60 * 1000,
  });
  return {
    coords: query.data ?? null,
    unavailable: query.isError,
    loading: query.isLoading,
    refetch: query.refetch,
  };
}
