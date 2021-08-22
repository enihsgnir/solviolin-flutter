import 'package:solviolin_admin/util/format.dart';

class Ledger {
  int amount;
  String userID;
  int termID;
  String branchName;
  DateTime paidAt;

  Ledger({
    required this.amount,
    required this.userID,
    required this.termID,
    required this.branchName,
    required this.paidAt,
  });

  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      amount: json["amount"],
      userID: json["userID"],
      termID: json["termID"],
      branchName: json["branchName"],
      paidAt: parseDateTime(json["paidAt"]).add(const Duration(hours: 9)),
    );
  }
}
