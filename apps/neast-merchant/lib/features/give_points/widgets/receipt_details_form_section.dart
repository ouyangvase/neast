import 'package:flutter/material.dart';
import 'package:neast/features/give_points/give_points_colors.dart';

/// Receipt Details 表单区。
class ReceiptDetailsFormSection extends StatelessWidget {
  const ReceiptDetailsFormSection({
    super.key,
    required this.outletName,
    required this.receiptNumberController,
    required this.amountController,
    required this.notesController,
  });

  final String outletName;
  final TextEditingController receiptNumberController;
  final TextEditingController amountController;
  final TextEditingController notesController;

  static const _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: GivePointsColors.formLabel,
  );

  static const _valueStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: GivePointsColors.formValue,
  );

  static const _fieldGap = 6.0;
  static const _groupGap = 16.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(4));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _readOnlyField(label: 'Outlet', value: outletName),
          const SizedBox(height: _groupGap),
          _field(
            label: 'Receipt Number',
            controller: receiptNumberController,
            hint: 'e.g. R-2604-1108',
          ),
          const SizedBox(height: _groupGap),
          _amountField(),
          const SizedBox(height: _groupGap),
          _field(
            label: 'Notes (Optional)',
            controller: notesController,
            hint: 'e.g. Table 12, latte set',
            minLines: 1,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: _fieldGap),
        InputDecorator(
          decoration: _inputDecoration().copyWith(
            filled: true,
            fillColor: GivePointsColors.background,
          ),
          child: Text(
            value.isNotEmpty ? value : '-',
            style: _valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? hint,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: _fieldGap),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          style: _valueStyle,
          decoration: _inputDecoration(hint: hint),
        ),
      ],
    );
  }

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Receipt Amount', style: _labelStyle),
        const SizedBox(height: _fieldGap),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: _valueStyle,
          decoration: _inputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Text('RM', style: _labelStyle),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
  }) {
    const borderSide = BorderSide(color: GivePointsColors.formBorder);

    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      isDense: true,
      hintStyle: _labelStyle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: const OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: borderSide,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: borderSide,
      ),
      border: const OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: borderSide,
      ),
    );
  }
}
