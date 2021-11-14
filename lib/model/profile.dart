class Profile {
  String userID;
  String branchName;

  Profile({
    required this.userID,
    required this.branchName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"].trim(),
      branchName: json["branchName"],
    );
  }
}
