import 'package:solviolin_admin/util/format.dart';

class Control {
  int id;
  DateTime controlStart;
  DateTime controlEnd;
  String teacherID;
  String branchName;

  /// `0`: Open, `1`: Close
  int status;

  /// `0`: None, `1`: Cancel, `2`: Delete
  int? cancelInClose;

  Control({
    required this.id,
    required this.controlStart,
    required this.controlEnd,
    required this.teacherID,
    required this.branchName,
    required this.status,
    this.cancelInClose,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json["id"],
      controlStart: parseDateTime(json["controlStart"]),
      controlEnd: parseDateTime(json["controlEnd"]),
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
      status: json["status"],
      cancelInClose: json["cancelInClose"],
    );
  }

  @override
  String toString() =>
      "$teacherID / $branchName / " +
      (status == 0
          ? "오픈"
          : "클로즈" +
              () {
                switch (cancelInClose) {
                  case 0:
                    return "(유지)";
                  case 1:
                    return "(취소)";
                  case 2:
                    return "(삭제)";
                  default:
                    return "";
                }
              }()) +
      "\n시작: " +
      formatDateTime(controlStart) +
      "\n종료: " +
      formatDateTime(controlEnd);
}

enum ControlStatus {
  open,
  close,
}

extension ControlStatusExtension on ControlStatus {
  String get name => ["오픈", "클로즈"][index];
}

enum CancelInClose {
  none,
  cancel,
  delete,
}

extension CancelInCloseExtension on CancelInClose {
  String get name => ["유지", "취소", "삭제"][index];
}
