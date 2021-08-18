import 'package:solviolin_admin/model/ledger.dart';

class User {
  String userID;
  String userName;
  String userPhone;
  int userType;
  String branchName;
  int userCredit;
  int status;
  String? color;
  List<Ledger> ledgers;

  User({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.userType,
    required this.branchName,
    required this.userCredit,
    required this.status,
    this.color,
    required this.ledgers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"],
      userName: json["userName"],
      userPhone: json["userPhone"],
      userType: json["userType"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      status: json["status"],
      color: json["color"],
      ledgers: List<Ledger>.generate(
        json["ledgers"].length,
        (index) => Ledger.fromJson(json["ledgers"][index]),
      )..sort((a, b) => b.paidAt.compareTo(a.paidAt)),
    );
  }
}
