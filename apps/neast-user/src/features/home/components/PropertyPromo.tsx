import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { Chevron, userHomeColors } from '@neast/ui-mobile';

import propertyHero from '../../../../assets/images/home/property-hero-generated.png';

/** Property promo (web parity) → /properties placeholder. */
export function PropertyPromo() {
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel="Explore properties"
      onPress={() => router.push('/properties')}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      <Image source={propertyHero} resizeMode="cover" style={styles.image} />
      <View style={styles.panel}>
        <Text style={styles.title}>Find a home</Text>
        <Text style={styles.note}>Listings on NEAST are opening soon.</Text>
        <View style={styles.exploreLink}>
          <Text style={styles.exploreLinkText}>View properties</Text>
          <Chevron direction="right" color={userHomeColors.surface} size={8} />
        </View>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    minHeight: 108,
    borderRadius: 16,
    overflow: 'hidden',
    flexDirection: 'row',
    backgroundColor: userHomeColors.navy,
    borderWidth: 1,
    borderColor: userHomeColors.border,
  },
  image: {
    position: 'absolute',
    left: 0,
    top: 0,
    width: '44%',
    height: '100%',
  },
  panel: {
    flex: 1,
    marginLeft: '44%',
    padding: 14,
    justifyContent: 'center',
    gap: 5,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 17,
    lineHeight: 22,
    fontWeight: '700',
  },
  note: {
    color: userHomeColors.textOnNavyAlt,
    fontSize: 12,
    lineHeight: 17,
  },
  exploreLink: {
    flexDirection: 'row',
    alignSelf: 'flex-start',
    alignItems: 'center',
    gap: 4,
    marginTop: 2,
  },
  exploreLinkText: {
    color: userHomeColors.surface,
    fontSize: 13,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.82,
  },
});
