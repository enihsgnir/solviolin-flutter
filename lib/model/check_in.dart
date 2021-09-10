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
      userID: json["userID"],
      branchName: json["branchName"],
      createdAt: parseDateTime(json["createdAt"]),
    );
  }
}
