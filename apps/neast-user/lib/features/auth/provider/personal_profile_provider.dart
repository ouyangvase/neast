import 'package:flutter_riverpod/flutter_riverpod.dart';

enum IdDocumentType { idCard, passport }

class PersonalProfileState {
  const PersonalProfileState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.idDocumentType = IdDocumentType.idCard,
    this.idNumber = '',
    this.validUntil,
    this.address = '',
    this.invitationCode = '',
  });

  final String firstName;
  final String lastName;
  final String email;
  final IdDocumentType idDocumentType;
  final String idNumber;
  final DateTime? validUntil;
  final String address;
  final String invitationCode;

  bool get showValidUntil => idDocumentType == IdDocumentType.passport;

  PersonalProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    IdDocumentType? idDocumentType,
    String? idNumber,
    DateTime? validUntil,
    bool clearValidUntil = false,
    String? address,
    String? invitationCode,
  }) {
    return PersonalProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      idDocumentType: idDocumentType ?? this.idDocumentType,
      idNumber: idNumber ?? this.idNumber,
      validUntil: clearValidUntil ? null : (validUntil ?? this.validUntil),
      address: address ?? this.address,
      invitationCode: invitationCode ?? this.invitationCode,
    );
  }
}

class PersonalProfileNotifier extends Notifier<PersonalProfileState> {
  @override
  PersonalProfileState build() => const PersonalProfileState();

  void setFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  void setLastName(String value) {
    state = state.copyWith(lastName: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setIdDocumentType(IdDocumentType type) {
    if (type == IdDocumentType.idCard) {
      state = state.copyWith(
        idDocumentType: type,
        clearValidUntil: true,
      );
      return;
    }
    state = state.copyWith(idDocumentType: type);
  }

  void setIdNumber(String value) {
    state = state.copyWith(idNumber: value);
  }

  void setValidUntil(DateTime? value) {
    state = state.copyWith(validUntil: value);
  }

  void setAddress(String value) {
    state = state.copyWith(address: value);
  }

  void setInvitationCode(String value) {
    state = state.copyWith(invitationCode: value);
  }

  void reset() {
    state = const PersonalProfileState();
  }
}

final personalProfileProvider =
    NotifierProvider<PersonalProfileNotifier, PersonalProfileState>(
  PersonalProfileNotifier.new,
);
