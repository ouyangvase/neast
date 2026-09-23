/**
 * Metro asset module declarations for this package's own typecheck.
 *
 * Metro resolves static asset imports to a numeric asset reference
 * (`ImageSourcePropType`-compatible). These declarations are local to the
 * `@neast/ui-mobile` typecheck; consuming apps resolve the same imports
 * through their own ambient declarations (e.g. `expo/types`).
 */
declare module '*.png' {
  const src: number;
  export default src;
}

declare module '*.svg' {
  // Exported as a plain Metro asset reference. Apps that configure
  // react-native-svg-transformer should import the SVG file directly instead.
  const src: number;
  export default src;
}

declare module '*.ttf' {
  const src: number;
  export default src;
}
