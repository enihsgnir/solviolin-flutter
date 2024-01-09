import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change.freezed.dart';
part 'change.g.dart';

@freezed
class Change with _$Change {
  const factory Change({
    required ChangeFrom from,
    ChangeTo? to,
  }) = _Change;

  const Change._();

  String get teacherID => from.teacherID;
  String get branchName => from.branchName;
  DateTime get fromStartDate => from.startDate;
  DateTime get fromEndDate => from.endDate;
  DateTime? get toStartDate => to?.startDate;
  DateTime? get toEndDate => to?.endDate;

  factory Change.fromJson(Map<String, dynamic> json) => _$ChangeFromJson(json);
}

@freezed
class ChangeFrom with _$ChangeFrom {
  const factory ChangeFrom({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
  }) = _ChangeFrom;

  factory ChangeFrom.fromJson(Map<String, dynamic> json) =>
      _$ChangeFromFromJson(json);
}

@freezed
class ChangeTo with _$ChangeTo {
  const factory ChangeTo({
    required DateTime startDate,
    required DateTime endDate,
  }) = _ChangeTo;

  factory ChangeTo.fromJson(Map<String, dynamic> json) =>
      _$ChangeToFromJson(json);
}
