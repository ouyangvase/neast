import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final String account;
  final String password;

  const LoginState({
    this.account = '',
    this.password = '',
  });

  LoginState copyWith({
    String? account,
    String? password,
  }) {
    return LoginState(
      account: account ?? this.account,
      password: password ?? this.password,
    );
  }

  bool get canSubmit =>
      account.trim().isNotEmpty && password.trim().isNotEmpty;
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setAccount(String account) {
    state = state.copyWith(account: account);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void reset() {
    state = const LoginState();
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
