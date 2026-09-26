import { useWindowDimensions } from 'react-native';
import RenderHTML, {
  type MixedStyleDeclaration,
  type RenderHTMLProps,
} from 'react-native-render-html';

import { coreColors, userHomeColors } from '@ui/tokens/colors';

export interface RichTextProps {
  /** Agreement / legal HTML (from the agreement detail endpoint). */
  html: string;
  /** Horizontal padding already applied by the parent — keeps contentWidth correct. */
  contentPadding?: number;
  baseStyle?: MixedStyleDeclaration;
  tagsStyles?: RenderHTMLProps['tagsStyles'];
}

/** HTML renderer for agreement / legal pages (flutter_html equivalent). */
export function RichText({ html, contentPadding = 0, baseStyle, tagsStyles }: RichTextProps) {
  const { width } = useWindowDimensions();
  return (
    <RenderHTML
      source={{ html }}
      contentWidth={width - contentPadding * 2}
      baseStyle={{
        color: coreColors.blackText,
        fontSize: 14,
        lineHeight: 22,
        ...baseStyle,
      }}
      tagsStyles={{
        h1: { fontSize: 22, lineHeight: 30 },
        h2: { fontSize: 18, lineHeight: 26 },
        a: { color: userHomeColors.navy },
        ...tagsStyles,
      }}
    />
  );
}
