import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/user_type.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String userID,
    required UserType userType,
    required String branchName,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
