import 'package:json_annotation/json_annotation.dart';

enum ControlStatus {
  @JsonValue(0)
  open("오픈"),

  @JsonValue(1)
  close("클로즈"),
  ;

  final String label;

  const ControlStatus(this.label);
}
