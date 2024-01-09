import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_info.freezed.dart';
part 'teacher_info.g.dart';

@freezed
class TeacherInfo with _$TeacherInfo {
  const factory TeacherInfo({
    required String teacherID,
    TeacherColor? teacher,
  }) = _TeacherInfo;

  const TeacherInfo._();

  Color? get color => teacher?.color;

  factory TeacherInfo.fromJson(Map<String, dynamic> json) =>
      _$TeacherInfoFromJson(json);
}

@freezed
class TeacherColor with _$TeacherColor {
  const factory TeacherColor({
    @ColorConverter() Color? color,
  }) = _TeacherColor;

  factory TeacherColor.fromJson(Map<String, dynamic> json) =>
      _$TeacherColorFromJson(json);
}

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Color(int.parse(json.replaceFirst("#", "FF"), radix: 16));
  }

  @override
  String toJson(Color object) {
    return object.value.toRadixString(16).toUpperCase().replaceFirst("FF", "#");
  }
}
