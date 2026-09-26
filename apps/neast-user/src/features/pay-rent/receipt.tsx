import { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Asset } from 'expo-asset';
import { File, Paths } from 'expo-file-system';
import * as Print from 'expo-print';
import * as Sharing from 'expo-sharing';
import { router } from 'expo-router';

import { formatRinggit, type RentListItem } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  spacing,
  textStyles,
  Toast,
  userHomeColors,
} from '@neast/ui-mobile';

import appIcon from '@assets/icon/app_icon.png';

import { rentHistoryStatusMeta } from '@/lib/format';
import type { RentHistoryEntry } from '@/lib/types';
import { useTabsStore } from '@/stores/tabs';
import { PaymentSuccessHero } from './components';

/** Paid-rent confirmation: the same rows and PDF receipt as recent payment details. */
export function PaymentReceipt({ rent, entry }: { rent: RentListItem; entry: RentHistoryEntry }) {
  const [downloading, setDownloading] = useState(false);
  const rows = [
    { label: 'Property name', value: rent.property_name },
    { label: 'Owner name', value: rent.landlord_name },
    { label: 'Rental period paid', value: entry.rental_period },
    { label: 'Amount', value: formatRinggit(entry.amount) },
    { label: 'Due date', value: entry.last_paid_date },
    { label: 'Paid date', value: entry.user_paid_at! },
    { label: 'Status', value: rentHistoryStatusMeta(entry.status).label },
    { label: 'Payment method', value: entry.payment_method! },
    { label: 'Reference no', value: entry.payment_no },
  ];

  const download = async () => {
    setDownloading(true);
    try {
      const icon = Asset.fromModule(appIcon);
      await icon.downloadAsync();
      const logo = await new File(icon.localUri!).base64();
      const printed = await Print.printToFileAsync({
        html: receiptHtml(rows, `data:image/png;base64,${logo}`),
      });
      const named = new File(Paths.cache, `${entry.payment_no}.pdf`);
      await new File(printed.uri).copy(named, { overwrite: true });
      await Sharing.shareAsync(named.uri, {
        mimeType: 'application/pdf',
        UTI: 'com.adobe.pdf',
        dialogTitle: 'Download receipt',
      });
    } catch {
      Toast.error('Could not download the receipt');
    } finally {
      setDownloading(false);
    }
  };

  return (
    <View style={styles.body}>
      <PaymentSuccessHero amount={formatRinggit(entry.amount)} period={entry.rental_period} />
      <Card style={styles.card}>
        {rows.map((row) => (
          <View key={row.label} style={styles.infoRow}>
            <Text style={styles.infoLabel}>{row.label}</Text>
            <Text style={styles.infoValue}>{row.value}</Text>
          </View>
        ))}
      </Card>
      <View style={styles.actions}>
        <Button
          title="Download receipt"
          variant="outline"
          fullWidth={false}
          onPress={() => void download()}
          loading={downloading}
          style={styles.download}
          textStyle={styles.downloadLabel}
        />
        <Button
          title="Back to Pay Rent"
          fullWidth={false}
          onPress={() => {
            useTabsStore.getState().select('payRent');
            router.dismissTo('/');
          }}
          style={styles.back}
        />
      </View>
    </View>
  );
}

function receiptHtml(rows: { label: string; value: string }[], logoUri: string): string {
  const lines = rows
    .map((row) => `<tr><td>${escapeHtml(row.label)}</td><td>${escapeHtml(row.value)}</td></tr>`)
    .join('');
  return `<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <style>
      body { font-family: Helvetica, Arial, sans-serif; color: ${userHomeColors.textPrimary}; margin: 32px; }
      .brand { text-align: center; margin-bottom: 24px; }
      img { width: 64px; height: 64px; }
      h1 { color: ${userHomeColors.navy}; font-size: 22px; margin: 12px 0 0; }
      table { width: 100%; border-collapse: collapse; }
      td { padding: 10px 0; border-bottom: 1px solid ${coreColors.borderLight}; vertical-align: top; font-size: 14px; }
      td:first-child { color: ${userHomeColors.textSecondary}; width: 46%; }
      td:last-child { text-align: right; font-weight: 600; }
    </style>
  </head>
  <body>
    <div class="brand">
      <img src="${logoUri}" alt="NEAST" />
      <h1>NEAST receipt</h1>
    </div>
    <table>${lines}</table>
  </body>
</html>`;
}

function escapeHtml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

const styles = StyleSheet.create({
  body: {
    gap: spacing.lg,
  },
  card: {
    gap: spacing.sm,
  },
  actions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  download: {
    flex: 1,
    backgroundColor: userHomeColors.surface,
    borderColor: userHomeColors.navy,
  },
  downloadLabel: {
    color: userHomeColors.navy,
  },
  back: {
    flex: 1,
    backgroundColor: userHomeColors.navy,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  infoLabel: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    color: userHomeColors.textPrimary,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
});
