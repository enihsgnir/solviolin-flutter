class AdminProfile {
  String userID;
  String userName;
  int userType;
  String branchName;

  AdminProfile({
    required this.userID,
    required this.userName,
    required this.userType,
    required this.branchName,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      userID: json["userID"],
      userName: json["userName"],
      userType: json["userType"],
      branchName: json["branchName"],
    );
  }
}
