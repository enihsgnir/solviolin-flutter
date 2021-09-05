class Profile {
  String userID;
  String userName;
  int userType;

  Profile({
    required this.userID,
    required this.userName,
    required this.userType,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"],
      userName: json["userName"],
      userType: json["userType"],
    );
  }
}
