import {
  coreColors,
  merchantAccentColors,
  ownerAccentColors,
  userAccentColors,
  userHomeColors,
} from './colors';

/** The three NEAST apps. */
export type AppId = 'user' | 'owner' | 'merchant';

export interface AppTheme {
  id: AppId;
  /** Core palette — identical in every app. */
  colors: typeof coreColors;
  /** Per-app accent set (see docs/apps-overview.md §8.2–8.4). */
  accents: typeof userAccentColors | typeof ownerAccentColors | typeof merchantAccentColors;
  /** Web-parity home palette — present on the user theme only. */
  home?: typeof userHomeColors;
  /** Signature gradients for this app (pass straight to `GradientHeader`). */
  gradients: {
    /** Primary header gradient. */
    header: readonly [string, string];
    /** Highlight / card gradient. */
    highlight: readonly [string, string];
  };
}

export const userTheme: AppTheme = {
  id: 'user',
  colors: coreColors,
  accents: userAccentColors,
  home: userHomeColors,
  gradients: {
    // User screens use the solid navy bar.
    header: [userHomeColors.navy, userHomeColors.navy],
    highlight: [userAccentColors.tierBackground, userAccentColors.gold],
  },
};

export const ownerTheme: AppTheme = {
  id: 'owner',
  colors: coreColors,
  accents: ownerAccentColors,
  gradients: {
    header: [ownerAccentColors.gradientBlueStart, ownerAccentColors.gradientBlueEnd],
    highlight: [ownerAccentColors.gradientWarmStart, ownerAccentColors.gradientWarmEnd],
  },
};

export const merchantTheme: AppTheme = {
  id: 'merchant',
  colors: coreColors,
  accents: merchantAccentColors,
  gradients: {
    header: [merchantAccentColors.gradientScanStart, merchantAccentColors.gradientScanEnd],
    highlight: [merchantAccentColors.gradientCardStart, merchantAccentColors.gradientCardEnd],
  },
};

export const appThemes: Record<AppId, AppTheme> = {
  user: userTheme,
  owner: ownerTheme,
  merchant: merchantTheme,
};

/** Per-app theme selector. */
export function getAppTheme(app: AppId): AppTheme {
  return appThemes[app];
}
