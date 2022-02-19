import 'package:solviolin_admin/util/format.dart';

class RegularSchedule {
  int id;
  Duration startTime;
  Duration endTime;

  /// `0`: SUN
  int dow;
  String userID;
  String teacherID;
  String branchName;

  // default: empty regular schedule
  RegularSchedule({
    this.id = -1,
    this.startTime = const Duration(),
    this.endTime = const Duration(),
    this.dow = -1,
    required this.userID,
    this.teacherID = "Null",
    required this.branchName,
  });

  factory RegularSchedule.fromJson(Map<String, dynamic> json) {
    return RegularSchedule(
      id: json["id"],
      startTime: parseTime(json["startTime"]),
      endTime: parseTime(json["endTime"]),
      dow: json["dow"],
      userID: json["userID"].trim(),
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
    );
  }

  @override
  String toString() =>
      "$teacherID / $branchName" +
      "\n$dowToString / ${timeToString(startTime)} ~ ${timeToString(endTime)}";

  String get dowToString =>
      {
        0: "SUN",
        1: "MON",
        2: "TUE",
        3: "WED",
        4: "THU",
        5: "FRI",
        6: "SAT",
        7: "SUN",
      }[dow] ??
      "Null";
}
