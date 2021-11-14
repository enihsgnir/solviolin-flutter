class Profile {
  String userID;
  int userType;
  String branchName;

  Profile({
    required this.userID,
    required this.userType,
    required this.branchName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"].trim(),
      userType: json["userType"],
      branchName: json["branchName"],
    );
  }
}
