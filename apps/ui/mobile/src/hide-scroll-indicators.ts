import { createElement, type ComponentType } from 'react';

/**
 * React Native 0.85 exports ScrollView as a function, so `defaultProps` never
 * reach it. The public export is a live getter, which FlatList and SectionList
 * also read when they render. Replace that getter; its `.default` is read-only.
 */
type ScrollViewType = ComponentType<Record<string, unknown>> & {
  Context?: object;
  displayName?: string;
  __hideScrollIndicators?: true;
};

type ScrollViewGetter = (() => ScrollViewType) & { __hideScrollIndicators?: true };

declare function require(id: string): object;

const ReactNative = require('react-native');
const descriptor = Object.getOwnPropertyDescriptor(ReactNative, 'ScrollView');
const originalGet = descriptor?.get as ScrollViewGetter | undefined;

if (originalGet && descriptor?.configurable && !originalGet.__hideScrollIndicators) {
  let cached: ScrollViewType | null = null;
  let cachedOriginal: ScrollViewType | null = null;

  const hiddenGet: ScrollViewGetter = function hiddenGet() {
    const Original = originalGet.call(ReactNative);
    if (cached && cachedOriginal === Original) {
      return cached;
    }
    const HiddenScrollView: ScrollViewType = (props) =>
      createElement(Original, {
        showsVerticalScrollIndicator: false,
        showsHorizontalScrollIndicator: false,
        ...props,
      });
    HiddenScrollView.Context = Original.Context;
    HiddenScrollView.displayName = 'ScrollView';
    HiddenScrollView.__hideScrollIndicators = true;
    cached = HiddenScrollView;
    cachedOriginal = Original;
    return HiddenScrollView;
  };
  hiddenGet.__hideScrollIndicators = true;

  Object.defineProperty(ReactNative, 'ScrollView', {
    configurable: true,
    enumerable: descriptor.enumerable,
    get: hiddenGet,
  });
}
