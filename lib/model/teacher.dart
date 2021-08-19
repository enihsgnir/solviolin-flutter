import 'package:solviolin_admin/util/format.dart';

class Teacher {
  String teacherID;
  String branchName;
  int workDow;
  Duration startTime;
  Duration endTime;

  Teacher({
    required this.teacherID,
    required this.branchName,
    required this.workDow,
    required this.startTime,
    required this.endTime,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      workDow: json["workDow"],
      startTime: parseTimeOnly(json["startTime"]),
      endTime: parseTimeOnly(json["endTime"]),
    );
  }
}
