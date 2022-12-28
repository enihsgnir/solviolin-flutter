import 'package:solviolin_admin/util/format.dart';

class Teacher {
  int id;
  String teacherID;
  String branchName;

  /// `0`: SUN
  int workDow;
  Duration startTime;
  Duration endTime;

  Teacher({
    required this.id,
    required this.teacherID,
    required this.branchName,
    required this.workDow,
    required this.startTime,
    required this.endTime,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json["id"],
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
      workDow: json["workDow"],
      startTime: parseTime(json["startTime"]),
      endTime: parseTime(json["endTime"]),
    );
  }

  @override
  String toString() =>
      "ID: $id" +
      "\n$teacherID / $branchName" +
      "\n$workDowToString / ${timeToString(startTime)} ~ ${timeToString(endTime)}";

  String get workDowToString =>
      {
        0: "SUN",
        1: "MON",
        2: "TUE",
        3: "WED",
        4: "THU",
        5: "FRI",
        6: "SAT",
        7: "SUN",
      }[workDow] ??
      "Null";
}
