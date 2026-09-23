import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/common/widgets/upload_progress_dialog.dart';
import 'package:neast/features/pay_rent/models/rent_property_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_provider.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';
import 'package:neast/features/pay_rent/utils/first_pay_month_util.dart';
import 'package:neast/features/pay_rent/utils/pay_rent_agreement_picker.dart';
import 'package:neast/features/pay_rent/widgets/first_pay_month_picker_sheet.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_day_picker_sheet.dart';
import 'package:neast/features/scan/utils/qr_scanner_launcher.dart';

/// Pay Rent 表单，包含字段与 Save 按钮。
class PayRentFormCard extends ConsumerStatefulWidget {
  const PayRentFormCard({super.key, this.onSaveSuccess});

  /// 保存成功后的回调（如创建页保存后返回列表）。
  final VoidCallback? onSaveSuccess;

  @override
  ConsumerState<PayRentFormCard> createState() => _PayRentFormCardState();
}

class _PayRentFormCardState extends ConsumerState<PayRentFormCard> {
  late final TextEditingController _propertyNameController;
  late final TextEditingController _leaseMonthsController;
  late final TextEditingController _amountController;
  late final TextEditingController _ownerNameController;

  static const _requiredColor = Color(0xFFFF4444);
  static const _fieldHeight = 48.0;
  static const _fieldSpacing = 16.0;
  static const _tenancyAgreementAsset =
      'assets/images/pay_rent/tenancy-agreement.png';
  static const _connectWithOwnerAsset =
      'assets/images/pay_rent/connect-with-owner.png';

  @override
  void initState() {
    super.initState();
    final state = ref.read(payRentProvider);
    _propertyNameController = TextEditingController(text: state.propertyName);
    _leaseMonthsController = TextEditingController(
      text: state.leaseMonthsInput,
    );
    _amountController = TextEditingController(text: state.amountInput);
    _ownerNameController = TextEditingController(text: state.ownerNameInput);
  }

  @override
  void dispose() {
    _propertyNameController.dispose();
    _leaseMonthsController.dispose();
    _amountController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  Future<void> _onPickPayDay() async {
    final state = ref.read(payRentProvider);
    final day = await showPayRentDayPicker(
      context: context,
      initialDay: state.payDay,
    );
    if (day != null) {
      ref.read(payRentProvider.notifier).setPayDay(day);
    }
  }

  Future<void> _onPickFirstPayMonth() async {
    final state = ref.read(payRentProvider);
    final payDay = state.payDay;
    if (payDay == null) {
      ToastUtil.show('Please select pay date first');
      return;
    }

    final month = await showFirstPayMonthPicker(
      context: context,
      payDay: payDay,
      initialMonth: state.firstPayMonth,
    );
    if (month != null) {
      ref.read(payRentProvider.notifier).setFirstPayMonth(month);
    }
  }

  Future<void> _onConnectWithOwner() async {
    final sn = await openQrScanner(context);
    if (sn == null || sn.trim().isEmpty || !mounted) return;

    await EasyLoading.show();
    try {
      final ok = await ref.runGuarded(
        () => ref.read(payRentProvider.notifier).bindPropertyBySn(sn),
      );
      if (ok != true || !mounted) return;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _onPickDemoOwner() async {
    final options = await ref.runGuarded(
      () => ref.read(rentServiceProvider).fetchConnectOptions(),
    );
    if (!mounted || options == null || options.isEmpty) {
      ToastUtil.show('No demo owner properties');
      return;
    }

    final selected = await showModalBottomSheet<RentPropertyModel>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Select owner property',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                  ),
                ),
              ),
              for (final item in options)
                ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.landlordName),
                  onTap: () => Navigator.of(context).pop(item),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || !mounted) return;
    ref.read(payRentProvider.notifier).bindConnectedProperty(selected);
  }

  Future<void> _onPickAgreement() async {
    final useSample = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tenancy agreement'),
          content: const Text(
            'Use a sample file for this local demo, or pick a file from the device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Choose file'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Use sample'),
            ),
          ],
        );
      },
    );
    if (!mounted || useSample == null) return;
    if (useSample) {
      ref.read(payRentProvider.notifier).setAgreementUpload(
            'demo/tenancy-agreement.pdf',
            'sample-agreement.pdf',
          );
      ToastUtil.show('Sample agreement attached');
      return;
    }

    final picked = await pickTenancyAgreement(context);
    if (picked == null || !mounted) return;

    final filePath = await uploadFileWithProgressDialog(
      context: context,
      ref: ref,
      file: picked.file,
      filename: picked.name,
    );
    if (!mounted || filePath == null || filePath.isEmpty) return;

    ref.read(payRentProvider.notifier).setAgreementUpload(
          filePath,
          picked.name,
        );
    ToastUtil.show('File uploaded');
  }

  Future<void> _onSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final notifier = ref.read(payRentProvider.notifier);
    if (!ref.read(payRentProvider).hasBoundProperty) {
      notifier.setPropertyNameInput(_propertyNameController.text.trim());
    }
    notifier.setLeaseMonthsInput(_leaseMonthsController.text);
    notifier.setAmountInput(_amountController.text.trim());
    if (!ref.read(payRentProvider).hasBoundProperty) {
      notifier.setOwnerNameInput(_ownerNameController.text.trim());
    }

    final validationError = notifier.validateForm();
    if (validationError != null) {
      ToastUtil.show(validationError);
      return;
    }

    await EasyLoading.show();
    try {
      final ok = await ref.runGuarded(() => notifier.submitCreate());
      if (ok == true) {
        ToastUtil.show('Saved successfully');
        widget.onSaveSuccess?.call();
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final payRentState = ref.watch(payRentProvider);

    if (payRentState.hasBoundProperty &&
        _propertyNameController.text != payRentState.propertyName) {
      _propertyNameController.text = payRentState.propertyName;
    }
    if (payRentState.hasBoundProperty &&
        _ownerNameController.text != payRentState.landlordName) {
      _ownerNameController.text = payRentState.landlordName;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TextInputField(
                    label: 'Property Name',
                    required: true,
                    brandBlue: brandBlue,
                    controller: _propertyNameController,
                    hintText: 'Name',
                    readOnly: payRentState.hasBoundProperty,
                    onChanged: payRentState.hasBoundProperty
                        ? null
                        : ref.read(payRentProvider.notifier).setPropertyNameInput,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  _SelectField(
                    label: 'Pay Date',
                    required: true,
                    brandBlue: brandBlue,
                    value: payRentState.payDay != null
                        ? formatPayDayLabel(payRentState.payDay!)
                        : null,
                    onTap: _onPickPayDay,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  _SelectField(
                    label: 'First Pay Month',
                    required: true,
                    brandBlue: brandBlue,
                    value: payRentState.firstPayMonth != null
                        ? formatFirstPayMonthLabel(payRentState.firstPayMonth!)
                        : null,
                    onTap: _onPickFirstPayMonth,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  _TextInputField(
                    label: 'Rental Amount',
                    required: true,
                    brandBlue: brandBlue,
                    controller: _amountController,
                    hintText: 'RM0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    onChanged: ref.read(payRentProvider.notifier).setAmountInput,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  _TextInputField(
                    label: 'Lease Term',
                    required: true,
                    brandBlue: brandBlue,
                    controller: _leaseMonthsController,
                    hintText: 'Months',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged:
                        ref.read(payRentProvider.notifier).setLeaseMonthsInput,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  _ActionField(
                    label: 'Tenancy Agreement',
                    required: true,
                    brandBlue: brandBlue,
                    hintText: 'Click to upload',
                    value: payRentState.agreementFileName.isNotEmpty
                        ? truncateFileName(payRentState.agreementFileName)
                        : null,
                    actionAsset: _tenancyAgreementAsset,
                    onTap: _onPickAgreement,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  const _FormLabel(label: 'Is the owner on NEAST?', required: true),
                  Row(
                    children: [
                      Expanded(
                        child: _OwnerPathChip(
                          label: 'Yes, on NEAST',
                          selected: payRentState.ownerOnNeast == true,
                          brandBlue: brandBlue,
                          onTap: () => ref
                              .read(payRentProvider.notifier)
                              .setOwnerOnNeast(true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _OwnerPathChip(
                          label: 'Not on NEAST',
                          selected: payRentState.ownerOnNeast == false,
                          brandBlue: brandBlue,
                          onTap: () => ref
                              .read(payRentProvider.notifier)
                              .setOwnerOnNeast(false),
                        ),
                      ),
                    ],
                  ),
                  if (payRentState.ownerOnNeast == true) ...[
                    const SizedBox(height: _fieldSpacing),
                    _ActionField(
                      label: 'Connect With Owner',
                      brandBlue: brandBlue,
                      hintText: payRentState.hasBoundProperty
                          ? payRentState.propertyName
                          : 'Scan QR or pick a demo owner',
                      actionAsset: _connectWithOwnerAsset,
                      onTap: _onConnectWithOwner,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _onPickDemoOwner,
                        child: const Text('Select demo owner property'),
                      ),
                    ),
                    if (payRentState.hasBoundProperty)
                      Text(
                        'Connected: ${payRentState.landlordName}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                  ],
                  if (payRentState.ownerOnNeast == false) ...[
                    const SizedBox(height: _fieldSpacing),
                    _TextInputField(
                      label: 'Owner Name',
                      required: true,
                      brandBlue: brandBlue,
                      controller: _ownerNameController,
                      hintText: 'Name only. Bank is collected at Pay Now.',
                      onChanged:
                          ref.read(payRentProvider.notifier).setOwnerNameInput,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 1),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OwnerPathChip extends StatelessWidget {
  const _OwnerPathChip({
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
    return Material(
      color: selected ? brandBlue : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? brandBlue : const Color(0xFFD0D5DD),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'HG',
              fontVariations: const [FontVariation('wght', 500)],
              color: selected ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel({
    required this.label,
    this.required = false,
  });

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (required)
            const Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _PayRentFormCardState._requiredColor,
              ),
            ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormBox extends StatelessWidget {
  const _FormBox({
    required this.brandBlue,
    required this.child,
    this.onTap,
  });

  final Color brandBlue;
  final Widget child;
  final VoidCallback? onTap;

  static const _borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: _PayRentFormCardState._fieldHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _borderRadius,
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      child: child,
    );

    if (onTap == null) return box;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        child: box,
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.brandBlue,
    required this.onTap,
    this.required = false,
    this.value,
  });

  final String label;
  final Color brandBlue;
  final VoidCallback onTap;
  final bool required;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(label: label, required: required),
        _FormBox(
          brandBlue: brandBlue,
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: value != null
                        ? brandBlue
                        : brandBlue.withValues(alpha: 0.35),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: brandBlue.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextInputField extends StatelessWidget {
  const _TextInputField({
    required this.label,
    required this.brandBlue,
    required this.controller,
    this.required = false,
    this.hintText,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final Color brandBlue;
  final TextEditingController controller;
  final bool required;
  final String? hintText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(label: label, required: required),
        _FormBox(
          brandBlue: brandBlue,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: brandBlue,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14,
                color: brandBlue.withValues(alpha: 0.35),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ActionField extends StatelessWidget {
  const _ActionField({
    required this.label,
    required this.brandBlue,
    required this.actionAsset,
    required this.onTap,
    this.required = false,
    this.hintText,
    this.value,
  });

  final String label;
  final Color brandBlue;
  final String actionAsset;
  final VoidCallback onTap;
  final bool required;
  final String? hintText;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final displayText = hasValue ? value! : (hintText ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(label: label, required: required),
        _FormBox(
          brandBlue: brandBlue,
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hasValue
                        ? brandBlue.withValues(alpha: 0.7)
                        : brandBlue.withValues(alpha: 0.35),
                  ),
                ),
              ),
              Image.asset(
                actionAsset,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
