import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode {
  login,
  signup;

  String get scene => this == AuthMode.login ? 'login' : 'register';

  String get routeValue => name;
}

class LoginState {
  final AuthMode mode;
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;

  const LoginState({
    this.mode = AuthMode.login,
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.countryCode = '+60',
  });

  LoginState copyWith({
    AuthMode? mode,
    String? firstName,
    String? lastName,
    String? phone,
    String? countryCode,
  }) {
    return LoginState(
      mode: mode ?? this.mode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  bool get canSubmitLogin => phone.trim().length >= 6;

  bool get canSubmitSignup =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      phone.trim().length >= 6;

  bool get canSubmit =>
      mode == AuthMode.login ? canSubmitLogin : canSubmitSignup;

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

  void setMode(AuthMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

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
