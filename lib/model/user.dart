import 'package:solviolin_admin/model/ledger.dart';

class User {
  String userID;
  String userName;
  String userPhone;
  String branchName;
  int userCredit;
  int status;
  List<Ledger> ledgers;

  User({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.branchName,
    required this.userCredit,
    required this.status,
    required this.ledgers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"],
      userName: json["userName"],
      userPhone: json["userPhone"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      status: json["status"],
      ledgers: List<Ledger>.generate(
        json["ledgers"].length,
        (index) => Ledger.fromJson(json["ledgers"][index]),
      )..sort((a, b) => b.paidAt.compareTo(a.paidAt)),
    );
  }
}
