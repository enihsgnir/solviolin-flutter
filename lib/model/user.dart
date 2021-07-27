class User {
  String userID;
  String userName;
  String userPhone;
  int userType;
  String branchName;
  int userCredit;
  String? token;
  int isPaid;
  int status;
  String? color;

  User({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.userType,
    required this.branchName,
    required this.userCredit,
    this.token,
    required this.isPaid,
    required this.status,
    this.color,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"],
      userName: json["userName"],
      userPhone: json["userPhone"],
      userType: json["userType"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      token: json["token"],
      isPaid: json["isPaid"],
      status: json["status"],
      color: json["color"],
    );
  }
}
