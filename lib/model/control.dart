import 'package:solviolin_admin/util/format.dart';

class Control {
  int id;
  DateTime controlStart;
  DateTime controlEnd;
  String teacherID;
  String branchName;
  int status;

  Control({
    required this.id,
    required this.controlStart,
    required this.controlEnd,
    required this.teacherID,
    required this.branchName,
    required this.status,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json["id"],
      controlStart: parseDateTime(json["controlStart"]),
      controlEnd: parseDateTime(json["controlEnd"]),
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      status: json["status"],
    );
  }
}
