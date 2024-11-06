import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'user_register_request.freezed.dart';
part 'user_register_request.g.dart';

@freezedRequestDto
class UserRegisterRequest with _$UserRegisterRequest {
  const factory UserRegisterRequest({
    required String userID,
    required String userPassword,
    required String userName,
    required String userPhone,
    required String userBranch,
    required UserType userType,
  }) = _UserRegisterRequest;

  @override
  Map<String, dynamic> toJson();
}
