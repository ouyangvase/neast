import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
abstract class MemberModel with _$MemberModel {
  factory MemberModel({
    required int id,
    required String name,
    required String phone,
    required String avatar,
    String? birthday,
    required int points,
    required int avatarType,
    int? isEmployee,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) 
    => _$MemberModelFromJson(json);
} 