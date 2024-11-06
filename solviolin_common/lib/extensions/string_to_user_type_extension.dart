import 'package:solviolin_common/models/user_type.dart';

extension StringToUserTypeExtension on String {
  UserType? toUserType() {
    return switch (this) {
      "student" => UserType.student,
      "teacher" => UserType.teacher,
      "admin" => UserType.admin,
      _ => null
    };
  }
}
