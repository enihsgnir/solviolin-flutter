import 'package:solviolin_admin/util/format.dart';

class User {
  String userID;
  String userName;
  String userPhone;
  String branchName;
  int userCredit;
  int status;
  List<DateTime> paidAt;

  User({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.branchName,
    required this.userCredit,
    required this.status,
    required this.paidAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"],
      userName: json["userName"],
      userPhone: json["userPhone"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      status: json["status"],
      paidAt: List<DateTime>.generate(
        json["ledgers"].length,
        (index) => parseDateTime(json["ledgers"][index]["paidAt"])
            .add(const Duration(hours: 9)),
      )..sort((a, b) => b.compareTo(a)),
    );
  }
}
