import 'package:solviolin_admin/util/format.dart';

class RegularSchedule {
  int id;
  Duration startTime;
  Duration endTime;
  int dow;
  String userID;
  String teacherID;
  String branchName;

  RegularSchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.dow,
    required this.userID,
    required this.teacherID,
    required this.branchName,
  });

  factory RegularSchedule.fromJson(Map<String, dynamic> json) {
    return RegularSchedule(
      id: json["id"],
      startTime: parseTimeOnly(json["startTime"]),
      endTime: parseTimeOnly(json["endTime"]),
      dow: json["dow"],
      userID: json["userID"].trim(),
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
    );
  }
}
