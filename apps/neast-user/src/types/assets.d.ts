/**
 * Metro asset module declarations for this app.
 *
 * `*.png` / `*.ttf` resolve to numeric Metro asset references.
 * `*.svg` goes through react-native-svg-transformer (see metro.config.js) and
 * resolves to a React component. NOTE: `@neast/ui-mobile`'s own typecheck
 * declares `*.svg` as a plain asset ref; that declaration is local to the
 * package and not part of this program, so there is no conflict here.
 */
declare module '*.png' {
  const src: number;
  export default src;
}

declare module '*.ttf' {
  const src: number;
  export default src;
}

declare module '*.svg' {
  import type { FC } from 'react';
  import type { SvgProps } from 'react-native-svg';
  const Component: FC<SvgProps>;
  export default Component;
}
