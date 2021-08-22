import 'package:flutter/material.dart';

class TeacherInfo {
  String teacherID;
  Color? color;

  TeacherInfo({
    required this.teacherID,
    this.color,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      teacherID: json["teacherID"],
      color: json["teacher"]["color"] == null
          ? null
          : Color(int.parse(
              "FF" + json["teacher"]["color"].substring(1),
              radix: 16,
            )),
    );
  }
}
