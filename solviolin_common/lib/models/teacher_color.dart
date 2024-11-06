import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/converters/color_converter.dart';

part 'teacher_color.freezed.dart';
part 'teacher_color.g.dart';

@freezed
class TeacherColor with _$TeacherColor {
  const factory TeacherColor({
    @ColorConverter() @Default(Color(0xFFFFFFFF)) Color color,
  }) = _TeacherColor;

  factory TeacherColor.fromJson(Map<String, dynamic> json) =>
      _$TeacherColorFromJson(json);
}
