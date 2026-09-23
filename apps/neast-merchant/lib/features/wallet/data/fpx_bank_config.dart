class FpxBankItem {
  const FpxBankItem({
    required this.name,
    required this.channel,
  });

  final String name;
  final String channel;
}

class FpxBankConfig {
  FpxBankConfig._();

  static const Map<String, String> banks = {
    'Affin Bank': 'fpx_abb',
    'Alliance Bank': 'fpx_abmb',
    'AmBank': 'fpx_amb',
    'BSN': 'fpx_bsn',
    'Bank Islam': 'fpx_bimb',
    'Bank Muamalat': 'fpx_bmmb',
    'Bank Rakyat': 'fpx_bkrm',
    'CIMB Clicks': 'fpx_cimbclicks',
    'HSBC Bank': 'fpx_hsbc',
    'Hong Leong Bank': 'fpx_hlb',
    'KFH': 'fpx_kfh',
    'Maybank2U': 'fpx_mb2u',
    'OCBC Bank': 'fpx_ocbc',
    'Public Bank': 'fpx_pbb',
    'RHB Bank': 'fpx_rhb',
    'Standard Chartered': 'fpx_scb',
    'UOB Bank': 'fpx_uob',
  };

  static final List<FpxBankItem> items = banks.entries
      .map((entry) => FpxBankItem(name: entry.key, channel: entry.value))
      .toList(growable: false);

  static String? nameOf(String? channel) {
    if (channel == null || channel.isEmpty) return null;
    for (final item in items) {
      if (item.channel == channel) return item.name;
    }
    return null;
  }
}
