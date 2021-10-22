import 'package:solviolin_admin/util/format.dart';

class User {
  String userID;
  String userPhone;
  int userType;
  String branchName;
  int userCredit;
  int status;
  List<DateTime> paidAt;

  User({
    required this.userID,
    required this.userPhone,
    required this.userType,
    required this.branchName,
    required this.userCredit,
    required this.status,
    required this.paidAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"],
      userPhone: json["userPhone"],
      userType: json["userType"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      status: json["status"],
      paidAt: List.generate(
        json["ledgers"].length,
        (index) => parseDateTime(json["ledgers"][index]["paidAt"])
            .add(const Duration(hours: 9)),
      )..sort((a, b) => b.compareTo(a)),
    );
  }
}
