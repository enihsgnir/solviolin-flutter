import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/control/control.dart';

part 'search_control_dto.freezed.dart';
part 'search_control_dto.g.dart';

@freezed
class SearchControlDto with _$SearchControlDto {
  const factory SearchControlDto({
    required String branchName,
    String? teacherID,
    DateTime? controlStart,
    DateTime? controlEnd,
    ControlStatus? status,
  }) = _SearchControlDto;

  factory SearchControlDto.fromJson(Map<String, dynamic> json) =>
      _$SearchControlDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
