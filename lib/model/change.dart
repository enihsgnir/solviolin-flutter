import 'package:solviolin/util/format.dart';

class Change {
  String teacherID;
  String branchName;
  DateTime fromStartDate;
  DateTime fromEndDate;
  DateTime? toStartDate;
  DateTime? toEndDate;

  Change({
    required this.teacherID,
    required this.branchName,
    required this.fromStartDate,
    required this.fromEndDate,
    this.toStartDate,
    this.toEndDate,
  });

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      teacherID: json["from"]["teacherID"].trim(),
      branchName: json["from"]["branchName"],
      fromStartDate: parseDateTime(json["from"]["startDate"]),
      fromEndDate: parseDateTime(json["from"]["endDate"]),
      toStartDate:
          json["to"] == null ? null : parseDateTime(json["to"]["startDate"]),
      toEndDate:
          json["to"] == null ? null : parseDateTime(json["to"]["endDate"]),
    );
  }

  @override
  String toString() =>
      "$teacherID / $branchName" +
      "\n변경 전: " +
      formatDateTimeRange(fromStartDate, fromEndDate) +
      (toStartDate == null
          ? "\n변경 사항이 없습니다."
          : "\n변경 후: " + formatDateTimeRange(toStartDate!, toEndDate!));
}
