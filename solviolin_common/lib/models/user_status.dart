import 'package:json_annotation/json_annotation.dart';

enum UserStatus {
  @JsonValue(0)
  unregistered("미등록"),

  @JsonValue(1)
  registered("등록"),
  ;

  final String label;

  const UserStatus(this.label);
}
