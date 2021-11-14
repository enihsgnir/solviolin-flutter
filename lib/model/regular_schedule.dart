import 'package:solviolin/util/format.dart';

class RegularSchedule {
  Duration startTime;
  Duration endTime;
  int dow;
  String teacherID;
  String branchName;

  RegularSchedule({
    required this.startTime,
    required this.endTime,
    required this.dow,
    required this.teacherID,
    required this.branchName,
  });

  factory RegularSchedule.fromJson(Map<String, dynamic> json) {
    return RegularSchedule(
      startTime: parseTimeOnly(json["startTime"]),
      endTime: parseTimeOnly(json["endTime"]),
      dow: json["dow"],
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
    );
  }
}
