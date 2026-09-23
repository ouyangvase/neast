import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final String phone;
  final String countryCode;

  const LoginState({
    this.phone = '',
    this.countryCode = '+60',
  });

  LoginState copyWith({
    String? phone,
    String? countryCode,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  bool get canSubmit => phone.trim().length >= 6;

  /// 区号（去掉 `+`）与号码拼接，如 `+60` + `123456` → `60123456`。
  String get fullPhoneAccount {
    final digits = phone.trim();
    if (digits.isEmpty) return '';
    final dial =
        countryCode.startsWith('+') ? countryCode.substring(1) : countryCode;
    return '$dial$digits';
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void setCountryCode(String countryCode) {
    state = state.copyWith(countryCode: countryCode);
  }

  void reset() {
    state = const LoginState();
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
