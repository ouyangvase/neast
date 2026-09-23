import { useFonts } from 'expo-font';

import funnelDisplay from '../../assets/fonts/FunnelDisplay-VariableFont_wght.ttf';
import hostGrotesk from '../../assets/fonts/HostGrotesk-VariableFont_wght.ttf';

/**
 * Font sources registered by `useBrandFonts`. Keys are the family names used
 * by `fontFamilies` / `textStyles` (`FunnelDisplay`, `HostGrotesk`).
 */
export const brandFontSources = {
  FunnelDisplay: funnelDisplay,
  HostGrotesk: hostGrotesk,
} as const;

export interface BrandFontsState {
  /** True once both brand fonts are ready to render. */
  loaded: boolean;
  /** Font load error, if any. */
  error: Error | null;
}

/**
 * Loads the NEAST brand fonts (Funnel Display + Host Grotesk) via expo-font.
 * Call once at the app root; gate rendering on `loaded` (or splash on `error`).
 */
export function useBrandFonts(): BrandFontsState {
  const [loaded, error] = useFonts(brandFontSources);
  return { loaded, error };
}
