class Profile {
  String userID;

  /// `0`: Student, `1`: Teacher, `2`: Admin
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
