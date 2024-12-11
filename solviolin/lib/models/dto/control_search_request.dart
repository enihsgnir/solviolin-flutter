import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/control_status.dart';
import 'package:solviolin/utils/freezed.dart';

part 'control_search_request.freezed.dart';
part 'control_search_request.g.dart';

@freezedRequestDto
class ControlSearchRequest with _$ControlSearchRequest {
  const factory ControlSearchRequest({
    required String branchName,
    String? teacherID,
    DateTime? controlStart,
    DateTime? controlEnd,
    ControlStatus? status,
  }) = _ControlSearchRequest;

  @override
  Map<String, dynamic> toJson();
}
