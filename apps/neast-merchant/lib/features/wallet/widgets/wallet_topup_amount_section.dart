import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 充值金额选择区：预设金额网格 + 自定义金额输入。
class WalletTopupAmountSection extends StatelessWidget {
  const WalletTopupAmountSection({
    super.key,
    required this.amounts,
    required this.selectedAmount,
    required this.onAmountSelected,
    required this.customController,
    required this.onCustomTap,
    required this.isCustomSelected,
  });

  static const tileRadius = 4.0;
  static const tileGap = 8.0;

  static const _selectedGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xFFB56F28),
      Color(0xFFE6C1A0),
    ],
  );

  final List<int> amounts;
  final int? selectedAmount;
  final ValueChanged<int> onAmountSelected;
  final TextEditingController customController;
  final VoidCallback onCustomTap;
  final bool isCustomSelected;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top-up amount',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileSize =
                (constraints.maxWidth - tileGap * 2) / 3;
            final customWidth = tileSize * 2 + tileGap;

            return Column(
              children: [
                Row(
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: tileGap),
                      SizedBox(
                        width: tileSize,
                        height: tileSize,
                        child: _AmountTile(
                          label: 'RM${amounts[i]}',
                          selected: !isCustomSelected &&
                              selectedAmount == amounts[i],
                          brandBlue: brandBlue,
                          onTap: () => onAmountSelected(amounts[i]),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: tileGap),
                Row(
                  children: [
                    SizedBox(
                      width: tileSize,
                      height: tileSize,
                      child: _AmountTile(
                        label: 'RM${amounts[3]}',
                        selected: !isCustomSelected &&
                            selectedAmount == amounts[3],
                        brandBlue: brandBlue,
                        onTap: () => onAmountSelected(amounts[3]),
                      ),
                    ),
                    const SizedBox(width: tileGap),
                    SizedBox(
                      width: customWidth,
                      height: tileSize,
                      child: _CustomAmountTile(
                        brandBlue: brandBlue,
                        controller: customController,
                        onTap: onCustomTap,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.label,
    required this.selected,
    required this.brandBlue,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color brandBlue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: selected ? WalletTopupAmountSection._selectedGradient : null,
          color: selected ? null : Colors.white,
          borderRadius:
              BorderRadius.circular(WalletTopupAmountSection.tileRadius),
          boxShadow: selected
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : brandBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomAmountTile extends StatelessWidget {
  const _CustomAmountTile({
    required this.brandBlue,
    required this.controller,
    required this.onTap,
  });

  final Color brandBlue;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(WalletTopupAmountSection.tileRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onTap: onTap,
                style: TextStyle(
                  fontSize: 14,
                  color: brandBlue.withValues(alpha: 0.5),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'RM',
                  hintStyle: TextStyle(
                    color: brandBlue.withValues(alpha: 0.35),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: brandBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: brandBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: brandBlue),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
