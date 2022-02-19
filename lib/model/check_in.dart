import 'package:solviolin_admin/util/format.dart';

class CheckIn {
  int id;
  String userID;
  String branchName;
  DateTime createdAt;

  CheckIn({
    required this.id,
    required this.userID,
    required this.branchName,
    required this.createdAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json["id"],
      userID: json["userID"].trim(),
      branchName: json["branchName"],
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
    );
  }

  @override
  String toString() =>
      "번호: $id" +
      "\n$userID / $branchName" +
      "\n체크인 시각: " +
      formatDateTime(createdAt);
}
