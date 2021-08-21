class Profile {
  String userID;
  String userName;
  int userType;
  String branchName;

  Profile({
    required this.userID,
    required this.userName,
    required this.userType,
    required this.branchName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"],
      userName: json["userName"],
      userType: json["userType"],
      branchName: json["branchName"],
    );
  }
}
