# @neast/ui-mobile

NEAST shared React Native design system for the Expo rebuild (SDK 56 / RN 0.85 / React 19).
Consumed **as source** (`"main": "src/index.ts"`) — no build step. All components use plain
`StyleSheet`; there is no styling-framework dependency.

## Install (app packages)

```bash
pnpm add @neast/ui-mobile
# peer native modules, pinned for Expo SDK 56:
pnpm add expo-font@~56.0.7 expo-camera@~56.0.8 expo-linear-gradient@~56.0.4 \
  react-native-webview@13.16.1 react-native-svg@15.15.4 \
  react-native-qrcode-svg@^6.3.26 react-native-render-html@^6.3.4
```

`react` (19.2.3) and `react-native` (0.85.x) are peer dependencies — the app already has them.

## Tokens & themes

```ts
import {
  coreColors,
  userAccentColors,
  ownerAccentColors,
  merchantAccentColors,
} from '@neast/ui-mobile';
import { radii, spacing, cardShadow } from '@neast/ui-mobile';
import { fontFamilies, textStyles } from '@neast/ui-mobile';
import { appThemes, getAppTheme, type AppId, type AppTheme } from '@neast/ui-mobile';

const theme = getAppTheme('owner'); // 'user' | 'owner' | 'merchant'
theme.colors; // core palette (brandBlue #0851AA, actionGreen #4ADB77, error #E03C3C, …)
theme.accents; // per-app accent set (user gold tier / owner blue+tan / merchant corporate blue)
theme.gradients.header; // readonly [string, string] — pass to GradientHeader
```

Optional context API: `<UiThemeProvider app="merchant">` + `useUiTheme()`. Components take
explicit color props, so the provider is a convenience, not a requirement.

## Fonts

```tsx
import { useBrandFonts, fontFamilies, textStyles } from '@neast/ui-mobile';

function Root() {
  const { loaded, error } = useBrandFonts(); // FunnelDisplay + HostGrotesk via expo-font
  if (!loaded) return null;
  return <App />;
}
```

`fontFamilies.display` = Funnel Display (headings/numerals), `fontFamilies.body` = Host Grotesk.
`textStyles` presets: `displayLarge`, `heading1–3`, `body`, `bodySmall`, `caption`, `button`,
`numeric`. Note: RN has no `FontVariation('wght')`; presets carry explicit `fontWeight` and the
variable font is interpolated where the platform supports it.

## Components

All components are controlled, navigation-agnostic, and accept `style` overrides.

| Component                | Key props                                                                                                             | Notes                                                           |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `Button`                 | `title`, `onPress`, `variant: primary\|secondary\|outline\|danger\|ghost`, `size`, `loading`, `disabled`, `fullWidth` | primary = action green, radius 8                                |
| `Card`                   | `children`, `padded`, `onPress`, `flat`                                                                               | white, radius 12, elevation-2 shadow                            |
| `TextField`              | `label`, `error`, `hint`, `left`, `right`, + `TextInputProps`                                                         | focus/error border states                                       |
| `OtpInput`               | `value`, `onChange`, `onComplete`, `length=6`, `hasError`                                                             | hidden-input OTP boxes                                          |
| `PhoneField`             | `dialCode`, `onDialCodePress`, `phone`, `onPhoneChange`                                                               | `getFullPhoneNumber('+60','123')` → `'60123'` (no `+`, per API) |
| `CountryCodePicker`      | `visible`, `codes: string[]`, `onSelect`, `selectedCode`, `onClose`                                                   | bottom-sheet dial-code list                                     |
| `BottomSheet`            | `visible`, `onClose`, `title`, `maxHeight`, `dismissOnBackdrop`                                                       | slide-up modal sheet                                            |
| `ConfirmDialog`          | `visible`, `title`, `message`, `confirmText`, `onConfirm`, `onCancel`, `danger`, `countdownSeconds`                  | dim backdrop; countdown optional (delete 10s, terminate 5s)     |
| `Toast` + `<ToastHost/>` | `Toast.show/success/error/warning(msg)`                                                                               | mount host once; 1.5s global debounce                           |
| `Skeleton`               | `width`, `height`, `radius`                                                                                           | pulsing placeholder                                             |
| `EmptyState`             | `image`, `title`, `message`, `actionLabel`, `onAction`                                                                |                                                                 |
| `ComingSoon`             | `title`, `message`, `onBack`                                                                                          | Shared navy header, cream “Coming soon” label, message; no photo |
| `BrandHeader`            | `title` / `richTitle`, `subtitle`, `onBack`, `right`, `backgroundColor`, `chevronColor`                               | Flutter `neast_brand_header`                                    |
| `GradientHeader`         | `colors` (from `theme.gradients`), `title`, `onBack`, `right`, `children`                                             | expo-linear-gradient header                                     |
| `SectionHeader`          | `title`, `actionLabel`, `onActionPress`, `titleStyle`                                                                 |                                                                 |
| `StatusTag`              | `label`, `status: pending\|overdue\|paid\|settled\|cancelled\|success\|failed\|info`, or `color`+`backgroundColor`    |                                                                 |
| `PaymentMethodSection`   | `methods: PaymentMethod[]`, `selectedId`, `onSelect`                                                                  | ids: `fpx/tng/grab/visa/wallet`; `feeLabel` trailing            |
| `FpxBankPicker`          | `visible`, `onSelect(bank)`, `selectedChannel`, `onClose`                                                             | `FPX_BANKS` = 17 banks with Fiuu channels                       |
| `MonthPicker`            | `visible`, `onSelect({year, month})`, `selected`, `months?`                                                           | default = rolling 12 months (`getRollingMonths`)                |
| `RefreshList<T>`         | `data`, `refreshing`, `onRefresh`, `onLoadMore`, `hasMore`, `loadingMore`, `renderItem`, …FlatList props              | AppRefresher equivalent                                         |
| `QrCodeView`             | `value`, `size`, `color`, `logo`                                                                                      | wraps react-native-qrcode-svg                                   |
| `QrScannerScreen`        | `onScanned(value)`, `onClose`, `title`                                                                                | expo-camera, scan-line overlay, permission gate; fires once     |
| `FiuuH5WebView`          | `url`, `title`, `showHeader=true`, `onResult('success'\|'pending'\|'failed')`, `onCancel`, `gracePeriodMs=2500`       | see below                                                       |
| `RichText`               | `html`, `contentPadding`, `baseStyle`, `tagsStyles`                                                                   | wraps react-native-render-html                                  |
| `TabBar`                 | `items: TabBarItem[]`, `activeKey`, `onChange`                                                                        | selected `#0F172A` / unselected `#B0B0B0`; `showBeta` per item  |
| `BetaTag`                | `label='Beta'`                                                                                                        |                                                                 |
| `UploadProgressDialog`   | `visible`, `progress: 0..1`, `fileName`, `onCancel`                                                                   | chunked-upload progress                                         |
| `ImagePreview`           | `visible`, `source`, `onClose`, `caption`                                                                             | no pinch-zoom (needs gesture-handler; add in app if required)   |

### FiuuH5WebView contract (replicates the Flutter screen)

- Browser-like UA (iPhone Safari / Pixel Chrome), JS + DOM storage enabled, `window.open`
  override forwards non-http(s) schemes.
- Non `http/https/about/blob` navigations open externally via `Linking` — including Android
  `intent://` (`scheme=` extraction, `S.browser_fallback_url` fallback).
- Result detection is purely URL-substring based: `/pay_success.html` → `success`,
  `pay_pending` → `pending`, `pay_failed` → `failed`, reported once after a 2.5s grace period.
  There is no server polling — callers re-fetch state on `success`/`pending`.
- `showHeader` defaults to true. Set it false when the screen draws its own header.
- Header back button (when shown) and Android hardware back fire `onCancel`.

## Shared assets

```ts
import { sharedAssets } from '@neast/ui-mobile';
sharedAssets.walletBalanceIcon; // user + merchant wallet balance icon
sharedAssets.accountHeader; // owner account-header == merchant give_points header
sharedAssets.accountWalletIcon; // user wallet.svg == merchant wallet_top_up.svg (Metro asset ref)
sharedAssets.coin; // owner coin.png == merchant account/coin.png
```

Values are Metro asset references for `<Image source={…} />`. If your app configures
react-native-svg-transformer, import SVG files directly from `apps/ui/mobile/assets/images/` instead.

## Scripts

```bash
pnpm --filter @neast/ui-mobile typecheck
pnpm --filter @neast/ui-mobile lint
```
