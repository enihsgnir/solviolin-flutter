import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'control.freezed.dart';
part 'control.g.dart';

enum ControlStatus {
  @JsonValue(0)
  open,

  @JsonValue(1)
  close,
}

enum CancelInClose {
  @JsonValue(0)
  none,

  @JsonValue(1)
  cancel,

  @JsonValue(2)
  delete,
}

@freezed
class Control with _$Control {
  const factory Control({
    required int id,
    required DateTime controlStart,
    required DateTime controlEnd,
    required String teacherID,
    required String branchName,
    required ControlStatus status,
    CancelInClose? cancelInClose,
  }) = _Control;

  factory Control.fromJson(Map<String, dynamic> json) =>
      _$ControlFromJson(json);
}
