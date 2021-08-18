class AdminProfile {
  String userID;
  String userName;
  String userPhone;
  int userType;
  String branchName;
  int userCredit;
  String? token;
  int status;
  String? color;

  AdminProfile({
    required this.userID,
    required this.userName,
    required this.userPhone,
    required this.userType,
    required this.branchName,
    required this.userCredit,
    this.token,
    required this.status,
    this.color,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      userID: json["userID"],
      userName: json["userName"],
      userPhone: json["userPhone"],
      userType: json["userType"],
      branchName: json["branchName"],
      userCredit: json["userCredit"],
      token: json["token"],
      status: json["status"],
      color: json["color"],
    );
  }
}
