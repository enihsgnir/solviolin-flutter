import 'package:json_annotation/json_annotation.dart';

enum UserType {
  @JsonValue(0)
  student("수강생"),

  @JsonValue(1)
  teacher("강사"),

  @JsonValue(2)
  admin("관리자"),
  ;

  final String label;

  const UserType(this.label);
}
