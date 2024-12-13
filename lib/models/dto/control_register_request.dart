import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/cancel_in_close.dart';
import 'package:solviolin/models/control_status.dart';
import 'package:solviolin/utils/freezed.dart';

part 'control_register_request.freezed.dart';
part 'control_register_request.g.dart';

@freezedRequestDto
class ControlRegisterRequest with _$ControlRegisterRequest {
  const factory ControlRegisterRequest({
    required String branchName,
    required String teacherID,
    required DateTime controlStart,
    required DateTime controlEnd,
    required ControlStatus status,
    required CancelInClose cancelInClose,
  }) = _ControlRegisterRequest;

  @override
  Map<String, dynamic> toJson();
}
