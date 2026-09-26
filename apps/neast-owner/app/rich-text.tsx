import { ScrollView, StyleSheet, View } from 'react-native';
import { useLocalSearchParams } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { PageHeader, RichText, spacing, userHomeColors } from '@neast/ui-mobile';

import { getAgreement } from '@/lib/endpoints';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { Screen } from '@/components/Screen';

/** Agreement HTML page — About Us / Terms / Privacy. */
export default function RichTextRoute() {
  const { title } = useLocalSearchParams<{ title: string }>();

  const agreement = useQuery({
    queryKey: ['agreement', title],
    queryFn: () => getAgreement(title),
  });

  return (
    <Screen edges={[]}>
      <PageHeader title={title} />
      {agreement.data ? (
        <View style={styles.body}>
          <ScrollView contentContainerStyle={styles.content}>
            <RichText html={agreement.data.content} contentPadding={spacing.lg} />
          </ScrollView>
        </View>
      ) : agreement.isError ? (
        <ErrorState onRetry={() => agreement.refetch()} />
      ) : agreement.isPending ? (
        <LoadingState />
      ) : null}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  content: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
  },
});
