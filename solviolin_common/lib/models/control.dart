import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/converters/equivalent_date_time_converter.dart';
import 'package:solviolin_common/models/cancel_in_close.dart';
import 'package:solviolin_common/models/control_status.dart';

part 'control.freezed.dart';
part 'control.g.dart';

@freezed
class Control with _$Control {
  const factory Control({
    required int id,
    @EquivalentDateTimeConverter() required DateTime controlStart,
    @EquivalentDateTimeConverter() required DateTime controlEnd,
    required String teacherID,
    required String branchName,
    required ControlStatus status,
    CancelInClose? cancelInClose,
  }) = _Control;

  factory Control.fromJson(Map<String, dynamic> json) =>
      _$ControlFromJson(json);
}
