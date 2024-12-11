import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/utils/freezed.dart';

part 'teacher_terminate_request.freezed.dart';
part 'teacher_terminate_request.g.dart';

@freezedRequestDto
class TeacherTerminateRequest with _$TeacherTerminateRequest {
  const factory TeacherTerminateRequest({
    required String teacherID,
    required DateTime endDate,
  }) = _TeacherTerminateRequest;

  @override
  Map<String, dynamic> toJson();
}
