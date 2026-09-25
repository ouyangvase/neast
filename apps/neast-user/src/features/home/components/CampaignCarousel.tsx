import { useEffect, useRef, useState } from 'react';
import {
  FlatList,
  Image,
  Linking,
  Pressable,
  StyleSheet,
  useWindowDimensions,
  View,
  type ImageSourcePropType,
  type NativeScrollEvent,
  type NativeSyntheticEvent,
} from 'react-native';

import type { HomeBanner } from '@neast/types';
import { userHomeColors } from '@neast/ui-mobile';

import yoyoLuckinCampaign from '../../../../assets/images/home/yoyo-luckin-campaign.png';
import campaignSampleCity from '../../../../assets/images/home/campaign-sample-city.png';
import campaignSampleHome from '../../../../assets/images/home/campaign-sample-home.png';

interface Slide {
  id: string;
  image: ImageSourcePropType;
  url: string;
}

const SAMPLE_SLIDES: Slide[] = [
  {
    id: 'yoyo-luckin',
    image: yoyoLuckinCampaign,
    url: 'https://www.sina.cn/news/detail/5339379767444744.html',
  },
  {
    id: 'sample-city',
    image: campaignSampleCity,
    url: 'https://neast.my',
  },
  {
    id: 'sample-home',
    image: campaignSampleHome,
    url: 'https://neast.my',
  },
];

interface CampaignCarouselProps {
  banners: HomeBanner[];
}

/** Full-bleed campaign photos. Admin banners replace the local samples. */
export function CampaignCarousel({ banners }: CampaignCarouselProps) {
  const { width } = useWindowDimensions();
  const cardWidth = width - 28;
  const slides: Slide[] =
    banners.length > 0
      ? banners.map((banner) => ({
          id: String(banner.id),
          image: { uri: banner.image_url },
          url: banner.link,
        }))
      : SAMPLE_SLIDES;

  const listRef = useRef<FlatList<Slide>>(null);
  const pausedRef = useRef(false);
  const [index, setIndex] = useState(0);

  useEffect(() => {
    setIndex(0);
    listRef.current?.scrollToOffset({ offset: 0, animated: false });
  }, [slides.length, cardWidth]);

  useEffect(() => {
    if (slides.length < 2) return;
    const timer = setInterval(() => {
      if (pausedRef.current) return;
      setIndex((current) => {
        const next = (current + 1) % slides.length;
        listRef.current?.scrollToIndex({ index: next, animated: true });
        return next;
      });
    }, 4000);
    return () => clearInterval(timer);
  }, [slides.length]);

  const onMomentumScrollEnd = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    const next = Math.round(event.nativeEvent.contentOffset.x / cardWidth);
    setIndex(next);
    pausedRef.current = false;
  };

  return (
    <View>
      <FlatList
        ref={listRef}
        horizontal
        pagingEnabled
        data={slides}
        keyExtractor={(item) => item.id}
        showsHorizontalScrollIndicator={false}
        getItemLayout={(_, itemIndex) => ({
          length: cardWidth,
          offset: cardWidth * itemIndex,
          index: itemIndex,
        })}
        onScrollBeginDrag={() => {
          pausedRef.current = true;
        }}
        onScrollEndDrag={() => {
          pausedRef.current = false;
        }}
        onMomentumScrollEnd={onMomentumScrollEnd}
        renderItem={({ item }) => (
          <Pressable
            accessibilityRole="link"
            accessibilityLabel="Open campaign"
            onPress={() => void Linking.openURL(item.url)}
            style={[styles.card, { width: cardWidth }]}
          >
            <Image source={item.image} style={styles.image} resizeMode="cover" />
          </Pressable>
        )}
      />
      {slides.length > 1 ? (
        <View style={styles.dots}>
          {slides.map((slide, dotIndex) => (
            <View
              key={slide.id}
              style={[styles.dot, dotIndex === index && styles.dotActive]}
            />
          ))}
        </View>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 22,
    overflow: 'hidden',
    backgroundColor: userHomeColors.campaignBlue,
    aspectRatio: 2,
  },
  image: {
    width: '100%',
    height: '100%',
  },
  dots: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 6,
    marginTop: 8,
  },
  dot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: 'rgba(255,255,255,0.45)',
  },
  dotActive: {
    width: 16,
    backgroundColor: userHomeColors.surface,
  },
});
