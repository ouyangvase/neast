import {
  Image,
  Pressable,
  StyleSheet,
  Text,
  View,
  type ImageSourcePropType,
  type StyleProp,
  type ViewStyle,
} from 'react-native';
import { isValidElement, type ReactNode } from 'react';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { BetaTag } from './BetaTag';

export interface TabBarItem {
  key: string;
  label: string;
  /** Inactive icon — Metro asset or a custom node (e.g. an SVG component). */
  icon?: ImageSourcePropType | ReactNode;
  /** Active icon; falls back to `icon`. */
  activeIcon?: ImageSourcePropType | ReactNode;
  /** Show the "Beta" badge on this tab (Flutter main bar has one). */
  showBeta?: boolean;
}

export interface TabBarProps {
  items: TabBarItem[];
  activeKey: string;
  onChange: (key: string) => void;
  style?: StyleProp<ViewStyle>;
}

function renderIcon(icon: ImageSourcePropType | ReactNode | undefined, tint: string): ReactNode {
  if (icon == null) return null;
  // React elements (e.g. an SVG component) render as-is; anything else is
  // treated as a Metro asset / `{ uri }` image source.
  if (isValidElement(icon)) return icon;
  return (
    <Image
      source={icon as ImageSourcePropType}
      style={[styles.icon, { tintColor: tint }]}
      resizeMode="contain"
    />
  );
}

/**
 * Bottom tab bar — selected `#0F172A`, unselected `#B0B0B0`
 * (docs/apps-overview.md §8.1). Navigation-agnostic: wire `onChange` to your
 * router's tab switch.
 */
export function TabBar({ items, activeKey, onChange, style }: TabBarProps) {
  return (
    <View style={[styles.bar, style]}>
      {items.map((item) => {
        const active = item.key === activeKey;
        const tint = active ? coreColors.tabSelected : coreColors.tabUnselected;
        return (
          <Pressable
            key={item.key}
            style={styles.item}
            onPress={() => onChange(item.key)}
            accessibilityRole="tab"
            accessibilityState={{ selected: active }}
          >
            <View>
              {renderIcon(active ? (item.activeIcon ?? item.icon) : item.icon, tint)}
              {item.showBeta ? <BetaTag style={styles.beta} /> : null}
            </View>
            <Text style={[styles.label, { color: tint }]}>{item.label}</Text>
          </Pressable>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    flexDirection: 'row',
    backgroundColor: coreColors.white,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: coreColors.divider,
    paddingTop: spacing.sm,
    paddingBottom: spacing.lg,
  },
  item: {
    flex: 1,
    alignItems: 'center',
    gap: 2,
  },
  icon: {
    width: 24,
    height: 24,
  },
  beta: {
    position: 'absolute',
    top: -6,
    right: -18,
  },
  label: {
    ...textStyles.caption,
    fontSize: 10,
  },
});
