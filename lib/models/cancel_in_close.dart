import 'package:json_annotation/json_annotation.dart';

enum CancelInClose {
  @JsonValue(0)
  none("유지"),

  @JsonValue(1)
  cancel("취소"),

  @JsonValue(2)
  delete("삭제"),
  ;

  final String label;

  const CancelInClose(this.label);
}
