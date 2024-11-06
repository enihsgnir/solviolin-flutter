import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/cancel_in_close.dart';
import 'package:solviolin_common/models/control_status.dart';

part 'control_register_form_data.freezed.dart';

@freezed
class ControlRegisterFormData with _$ControlRegisterFormData {
  const factory ControlRegisterFormData({
    @Default("") String branchName,
    @Default("") String teacherID,
    required DateTime controlStartDate,
    @Default(Duration.zero) Duration controlStartTime,
    required DateTime controlEndDate,
    @Default(Duration.zero) Duration controlEndTime,
    required ControlStatus status,
    required CancelInClose cancelInClose,
  }) = _ControlRegisterFormData;

  const ControlRegisterFormData._();

  bool get enabled =>
      branchName.isNotEmpty &&
      teacherID.isNotEmpty &&
      (controlStartDate
          .add(controlStartTime)
          .isBefore(controlEndDate.add(controlEndTime)));
}
