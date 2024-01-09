import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/control/control.dart';

part 'create_control_dto.freezed.dart';
part 'create_control_dto.g.dart';

@freezed
class CreateControlDto with _$CreateControlDto {
  const factory CreateControlDto({
    required String teacherID,
    required String branchName,
    required DateTime controlStart,
    required DateTime controlEnd,
    required ControlStatus status,
    required CancelInClose cancelInClose,
  }) = _CreateControlDto;

  factory CreateControlDto.fromJson(Map<String, dynamic> json) =>
      _$CreateControlDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
