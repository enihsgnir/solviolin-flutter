import 'package:solviolin/util/format.dart';

class RegularSchedule {
  Duration startTime;
  Duration endTime;

  /// 0: SUN
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

  @override
  String toString() =>
      "$teacherID / $branchName" +
      "\n${dowToString()} / ${timeToString(startTime)} ~ ${timeToString(endTime)}";

  String dowToString() =>
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
