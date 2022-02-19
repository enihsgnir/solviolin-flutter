import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/format.dart';

class TeacherInfo {
  String teacherID;

  /// `RegExp(r"^#[0-9A-Fa-f]{6}$")`
  Color? color;

  TeacherInfo({
    required this.teacherID,
    this.color,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      teacherID: json["teacherID"].trim(),
      color: parseColor(json["teacher"]["color"]),
    );
  }
}
