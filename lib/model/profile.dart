class Profile {
  String userID;
  int userType;

  Profile({
    required this.userID,
    required this.userType,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"],
      userType: json["userType"],
    );
  }
}
