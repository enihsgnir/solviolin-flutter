import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';

class Ledger {
  int id;
  num amount;
  String userID;
  int termID;
  String branchName;
  DateTime paidAt;

  Ledger({
    required this.id,
    required this.amount,
    required this.userID,
    required this.termID,
    required this.branchName,
    required this.paidAt,
  });

  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      id: json["id"],
      amount: json["amount"],
      userID: json["userID"].trim(),
      termID: json["termID"],
      branchName: json["branchName"],
      paidAt: DateTime.parse(json["paidAt"]).toLocal(),
    );
  }

  @override
  String toString() =>
      "$userID / $branchName / " +
      formatCurrency(amount) +
      "\n학기: $termIdToString" +
      "\n결제일자: " +
      formatDateTime(paidAt);

  String get termIdToString {
    final _data = Get.find<DataController>();

    final _index = _data.terms.indexWhere((element) => termID == element.id);
    return _index == -1
        ? formatDate(_data.terms.last.termStart) + " 이전"
        : () {
            final _term = _data.terms[_index];
            return formatDateRange(_term.termStart, _term.termEnd);
          }();
  }
}
