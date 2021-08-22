import 'package:solviolin_admin/util/format.dart';

class Canceled {
  DateTime startDate;
  DateTime endDate;
  String userID;
  String teacherID;
  String branchName;
  List<int> toID;

  Canceled({
    required this.startDate,
    required this.endDate,
    required this.userID,
    required this.teacherID,
    required this.branchName,
    required this.toID,
  });

  factory Canceled.fromJson(Map<String, dynamic> json) {
    return Canceled(
      startDate: parseDateTime(json["startDate"]),
      endDate: parseDateTime(json["endDate"]),
      userID: json["userID"],
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      toID: List<int>.generate(
        json["linkFrom"].length,
        (index) => json["linkFrom"][index]["toID"],
      ),
    );
  }
}
