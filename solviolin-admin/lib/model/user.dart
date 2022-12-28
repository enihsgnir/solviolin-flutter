import 'package:solviolin_admin/util/format.dart';

class User {
  String userID;
  String userName;

  /// `RegExp(r"^01([016789])-?(\d{3,4})-?(\d{4})$")`
  String userPhone;

  /// `0`: Student, `1`: Teacher, `2`: Admin
  int userType;
  String branchName;
  int userCredit;

  /// `0`: Unregistered, `1`: Registered
  int status;
  List<DateTime> paidAt;

  User({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.userType,
    required this.branchName,
    required this.userCredit,
    required this.status,
    required this.paidAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"].trim(),
      userName: json["userName"].trim(),
      userPhone: json["userPhone"].trim(),
      userType: json["userType"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      status: json["status"],
      paidAt: List.generate(
        json["ledgers"].length,
        (index) => DateTime.parse(json["ledgers"][index]["paidAt"]).toLocal(),
      )..sort((a, b) => b.compareTo(a)),
    );
  }

  @override
  String toString() =>
      "$userID / $branchName" +
      "\n${formatPhone(userPhone)}\n" +
      (status == 1 ? "등록" : "미등록") +
      " / 크레딧: $userCredit\n" +
      (paidAt.isEmpty ? "해당 학기 결제 미완료" : "결제일: " + formatDateTime(paidAt[0]));
}

enum UserType {
  student,
  teacher,
  admin,
}

extension UserTypeExtension on UserType {
  String get name => ["수강생", "강사", "관리자"][index];
}
