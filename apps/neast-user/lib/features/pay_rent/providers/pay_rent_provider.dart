import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/pay_rent/models/rent_property_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';
import 'package:neast/features/pay_rent/utils/first_pay_month_util.dart';

class PayRentState {
  const PayRentState({
    this.isEditing = false,
    this.payDay,
    this.firstPayMonth,
    this.amountInput = '',
    this.agreementFilePath = '',
    this.agreementFileName = '',
    this.leaseMonthsInput = '',
    this.propertyId,
    this.propertyName = '',
    this.landlordName = '',
    this.ownerNameInput = '',
    this.ownerOnNeast,
  });

  final bool isEditing;
  final int? payDay;
  final DateTime? firstPayMonth;
  final String amountInput;
  final String agreementFilePath;
  final String agreementFileName;
  final String leaseMonthsInput;
  final int? propertyId;
  final String propertyName;
  final String landlordName;
  final String ownerNameInput;
  final bool? ownerOnNeast;

  bool get hasBoundProperty =>
      propertyId != null && propertyId! > 0 && propertyName.isNotEmpty;

  PayRentState copyWith({
    bool? isEditing,
    int? payDay,
    bool clearPayDay = false,
    DateTime? firstPayMonth,
    bool clearFirstPayMonth = false,
    String? amountInput,
    String? agreementFilePath,
    bool clearAgreement = false,
    String? agreementFileName,
    String? leaseMonthsInput,
    int? propertyId,
    bool clearProperty = false,
    String? propertyName,
    String? landlordName,
    String? ownerNameInput,
    bool clearOwnerNameInput = false,
    bool? ownerOnNeast,
    bool clearOwnerOnNeast = false,
  }) {
    return PayRentState(
      isEditing: isEditing ?? this.isEditing,
      payDay: clearPayDay ? null : (payDay ?? this.payDay),
      firstPayMonth: clearFirstPayMonth
          ? null
          : (firstPayMonth ?? this.firstPayMonth),
      amountInput: amountInput ?? this.amountInput,
      agreementFilePath: clearAgreement
          ? ''
          : (agreementFilePath ?? this.agreementFilePath),
      agreementFileName: clearAgreement
          ? ''
          : (agreementFileName ?? this.agreementFileName),
      leaseMonthsInput: leaseMonthsInput ?? this.leaseMonthsInput,
      propertyId: clearProperty ? null : (propertyId ?? this.propertyId),
      propertyName: clearProperty ? '' : (propertyName ?? this.propertyName),
      landlordName: clearProperty ? '' : (landlordName ?? this.landlordName),
      ownerNameInput: clearOwnerNameInput
          ? ''
          : (ownerNameInput ?? this.ownerNameInput),
      ownerOnNeast: clearOwnerOnNeast
          ? null
          : (ownerOnNeast ?? this.ownerOnNeast),
    );
  }
}

class PayRentNotifier extends Notifier<PayRentState> {
  @override
  PayRentState build() {
    return const PayRentState();
  }

  void create() {
    if (state.isEditing) return;
    state = state.copyWith(
      isEditing: true,
      clearPayDay: true,
      clearFirstPayMonth: true,
      amountInput: '',
      clearAgreement: true,
      leaseMonthsInput: '',
      clearProperty: true,
      clearOwnerNameInput: true,
      clearOwnerOnNeast: true,
    );
  }

  void cancel() {
    if (!state.isEditing) return;
    state = state.copyWith(
      isEditing: false,
      clearPayDay: true,
      clearFirstPayMonth: true,
      amountInput: '',
      clearAgreement: true,
      leaseMonthsInput: '',
      clearProperty: true,
      clearOwnerNameInput: true,
      clearOwnerOnNeast: true,
    );
  }

  void setPayDay(int day) {
    var next = state.copyWith(payDay: day);
    final selectedMonth = next.firstPayMonth;
    if (selectedMonth != null &&
        !isFirstPayMonthAvailable(month: selectedMonth, payDay: day)) {
      next = next.copyWith(clearFirstPayMonth: true);
    }
    state = next;
  }

  void setFirstPayMonth(DateTime month) {
    state = state.copyWith(firstPayMonth: DateTime(month.year, month.month));
  }

  void setAmountInput(String value) {
    state = state.copyWith(amountInput: value);
  }

  void setAgreementUpload(String filePath, String fileName) {
    state = state.copyWith(
      agreementFilePath: filePath,
      agreementFileName: fileName,
    );
  }

  void setLeaseMonthsInput(String value) {
    state = state.copyWith(leaseMonthsInput: value);
  }

  void setPropertyNameInput(String value) {
    if (state.hasBoundProperty) return;
    state = state.copyWith(propertyName: value);
  }

  void setOwnerNameInput(String value) {
    state = state.copyWith(ownerNameInput: value);
  }

  void setOwnerOnNeast(bool value) {
    if (value) {
      state = state.copyWith(
        ownerOnNeast: true,
        clearOwnerNameInput: true,
      );
      return;
    }
    state = state.copyWith(
      ownerOnNeast: false,
      clearProperty: true,
    );
  }

  void bindConnectedProperty(RentPropertyModel property) {
    state = state.copyWith(
      ownerOnNeast: true,
      propertyId: property.id,
      propertyName: property.name,
      landlordName: property.landlordName,
    );
  }

  /// 扫码后通过 sn 绑定物业，成功返回 true。
  Future<bool> bindPropertyBySn(String sn) async {
    final trimmed = sn.trim();
    if (trimmed.isEmpty) return false;

    final property =
        await ref.read(rentServiceProvider).fetchPropertyBySn(trimmed);

    state = state.copyWith(
      ownerOnNeast: true,
      propertyId: property.id,
      propertyName: property.name,
      landlordName: property.landlordName,
    );
    return true;
  }

  /// 客户端校验，失败返回错误文案；成功返回 null。
  String? validateForm() {
    if (state.propertyName.trim().isEmpty) {
      return 'Please enter property name';
    }

    final payDay = state.payDay;
    if (payDay == null || payDay < 1 || payDay > 31) {
      return 'Please select pay date (1-31)';
    }

    final firstPayMonth = state.firstPayMonth;
    if (firstPayMonth == null) {
      return 'Please select first pay month';
    }
    if (!isFirstPayMonthAvailable(month: firstPayMonth, payDay: payDay)) {
      return 'Invalid first pay month for the selected pay date';
    }

    final amount = double.tryParse(state.amountInput.trim());
    if (amount == null || amount <= 0) {
      return 'Please enter rental amount (greater than 0)';
    }

    final months = int.tryParse(state.leaseMonthsInput.trim());
    if (months == null || months < 1) {
      return 'Please enter lease term (at least 1 month)';
    }

    if (state.agreementFilePath.isEmpty) {
      return 'Please upload tenancy agreement';
    }

    if (state.ownerOnNeast == null) {
      return 'Please choose whether the owner is on NEAST';
    }
    if (state.ownerOnNeast == true && !state.hasBoundProperty) {
      return 'Connect the owner property or pick a demo owner';
    }
    if (state.ownerOnNeast == false && state.ownerNameInput.trim().isEmpty) {
      return 'Please enter owner name';
    }

    return null;
  }

  Future<bool> submitCreate() async {
    if (!state.isEditing) return false;

    final error = validateForm();
    if (error != null) return false;

    final amount = double.parse(state.amountInput.trim());
    final payDay = state.payDay!;
    final leaseMonths = int.parse(state.leaseMonthsInput.trim());
    final firstPayMonth = formatFirstPayMonthValue(state.firstPayMonth!);

    await ref.read(rentServiceProvider).create(
          amount: amount,
          file: state.agreementFilePath,
          paidAt: payDay,
          firstPayMonth: firstPayMonth,
          leaseMonths: leaseMonths,
          propertyName: state.propertyName.trim(),
          propertyId: state.propertyId,
          ownerName: state.hasBoundProperty ? null : state.ownerNameInput.trim(),
        );

    ref.invalidate(payRentListProvider);

    state = state.copyWith(
      isEditing: false,
      clearPayDay: true,
      clearFirstPayMonth: true,
      amountInput: '',
      clearAgreement: true,
      leaseMonthsInput: '',
      clearProperty: true,
      clearOwnerNameInput: true,
      clearOwnerOnNeast: true,
    );
    return true;
  }
}

final payRentProvider = NotifierProvider<PayRentNotifier, PayRentState>(
  PayRentNotifier.new,
);
