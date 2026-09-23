import { createContext, useContext, useMemo, type ReactNode } from 'react';

import { getAppTheme, type AppId, type AppTheme } from './tokens/themes';

const UiThemeContext = createContext<AppTheme>(getAppTheme('user'));

export interface UiThemeProviderProps {
  /** Which NEAST app is rendering — selects the accent set. */
  app: AppId;
  children: ReactNode;
}

/**
 * Optional convenience provider. Components in this package also accept
 * explicit color/gradient props, so using the provider is not required.
 */
export function UiThemeProvider({ app, children }: UiThemeProviderProps) {
  const theme = useMemo(() => getAppTheme(app), [app]);
  return <UiThemeContext.Provider value={theme}>{children}</UiThemeContext.Provider>;
}

/** Current app theme (defaults to the user-app theme outside a provider). */
export function useUiTheme(): AppTheme {
  return useContext(UiThemeContext);
}
