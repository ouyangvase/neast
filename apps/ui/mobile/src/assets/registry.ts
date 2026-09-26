/**
 * Registry of genuinely shared image assets (byte-identical in two or more of
 * the Flutter apps — see the package README for the full duplication report).
 * App-specific artwork stays in each app's own assets folder.
 *
 * Values are Metro asset references — pass them straight to
 * `<Image source={...} />` or any `ImageSourcePropType` prop.
 */
import accountHeader from '@ui-assets/images/account-header.png';
import accountWalletIcon from '@ui-assets/images/account-wallet.svg';
import coin from '@ui-assets/images/coin.png';
import walletBalanceIcon from '@ui-assets/images/wallet-balance-icon.png';

export const sharedAssets = {
  /** Wallet balance card icon (was `images/wallet/balance-icon.png` in user + merchant). */
  walletBalanceIcon,
  /** Account/give-points header art (was owner `images/account-header.png` == merchant `images/give_points/header.png`). */
  accountHeader,
  /** Wallet menu icon (was user `images/account/wallet.svg` == merchant `images/account/wallet_top_up.svg`). Metro asset ref; import the file directly if your app uses an SVG transformer. */
  accountWalletIcon,
  /** Coin/points icon (was owner `images/coin.png` == merchant `images/account/coin.png`). */
  coin,
} as const;

export type SharedAssetName = keyof typeof sharedAssets;
