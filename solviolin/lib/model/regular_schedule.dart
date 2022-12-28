import 'package:solviolin/util/format.dart';

class RegularSchedule {
  Duration startTime;
  Duration endTime;

  /// `0`: SUN
  int dow;
  String teacherID;
  String branchName;

  // default: empty regular schedule
  RegularSchedule({
    this.startTime = const Duration(),
    this.endTime = const Duration(),
    this.dow = -1,
    this.teacherID = "Null",
    required this.branchName,
  });

  factory RegularSchedule.fromJson(Map<String, dynamic> json) {
    return RegularSchedule(
      startTime: parseTime(json["startTime"]),
      endTime: parseTime(json["endTime"]),
      dow: json["dow"],
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
