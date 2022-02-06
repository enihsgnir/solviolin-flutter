import 'package:solviolin/util/format.dart';

class Change {
  String teacherID;
  String branchName;
  DateTime fromDate;
  DateTime? toDate;

  Change({
    required this.teacherID,
    required this.branchName,
    required this.fromDate,
    this.toDate,
  });

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      teacherID: json["from"]["teacherID"].trim(),
      branchName: json["from"]["branchName"],
      fromDate: parseDateTime(json["from"]["startDate"]),
      toDate:
          json["to"] == null ? null : parseDateTime(json["to"]["startDate"]),
    );
  }

  @override
  String toString() =>
      "$teacherID / $branchName" +
      "\n변경 전: " +
      formatDateTime(fromDate) +
      (toDate == null
          ? "\n변경 사항이 없습니다."
          : "\n변경 후: " + formatDateTime(toDate!));
}
