import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/converters/time_converter.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'teacher_register_request.freezed.dart';
part 'teacher_register_request.g.dart';

@freezedRequestDto
class TeacherRegisterRequest with _$TeacherRegisterRequest {
  const factory TeacherRegisterRequest({
    required String teacherBranch,
    required String teacherID,
    required int workDow,
    @TimeConverter() required Duration startTime,
    @TimeConverter() required Duration endTime,
  }) = _TeacherCreateRequest;

  @override
  Map<String, dynamic> toJson();
}
