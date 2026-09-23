import { ScrollView, StyleSheet } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { GradientHeader, RichText, spacing, useUiTheme } from '@neast/ui-mobile';

import { getAgreement } from '../src/lib/endpoints';
import { ErrorState, LoadingState } from '../src/components/StateViews';
import { Screen } from '../src/components/Screen';

/** Agreement HTML page (rich_text_screen parity) — Legal. */
export default function RichTextRoute() {
  const theme = useUiTheme();
  const { title } = useLocalSearchParams<{ title: string }>();
  const pageTitle = title ?? '';

  const agreement = useQuery({
    queryKey: ['agreement', pageTitle],
    queryFn: () => getAgreement(pageTitle),
    enabled: pageTitle.length > 0,
  });

  return (
    <Screen edges={[]}>
      <GradientHeader
        colors={theme.gradients.header}
        title={pageTitle}
        onBack={() => router.back()}
      />
      {agreement.isLoading ? (
        <LoadingState />
      ) : agreement.isError ? (
        <ErrorState onRetry={() => agreement.refetch()} />
      ) : (
        <ScrollView contentContainerStyle={styles.content}>
          <RichText html={agreement.data?.content ?? ''} contentPadding={spacing.lg} />
        </ScrollView>
      )}
    </Screen>
  );
}

const styles = StyleSheet.create({
  content: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
  },
});
