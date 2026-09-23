/// 商家列表数据源类型。
enum MerchantListKind {
  all,
  recommended,
  nearby;

  static MerchantListKind? fromQuery(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final item in MerchantListKind.values) {
      if (item.name == value) return item;
    }
    return null;
  }
}

/// 商家列表页顶栏标题。
enum MerchantListHeaderTitle {
  merchants,
  nearbyMerchants;

  String get label => switch (this) {
        merchants => 'Merchants',
        nearbyMerchants => 'Nearby Merchants',
      };

  static MerchantListHeaderTitle? fromQuery(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value == 'suggestedMerchants') {
      return MerchantListHeaderTitle.nearbyMerchants;
    }
    for (final item in MerchantListHeaderTitle.values) {
      if (item.name == value) return item;
    }
    return null;
  }

  static MerchantListHeaderTitle resolve({
    required MerchantListKind kind,
    MerchantListHeaderTitle? override,
  }) {
    if (override != null) return override;
    return switch (kind) {
      MerchantListKind.all => merchants,
      MerchantListKind.recommended => merchants,
      MerchantListKind.nearby => nearbyMerchants,
    };
  }
}
