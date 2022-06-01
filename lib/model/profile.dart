class Profile {
  String _userID;
  String get userID => _userID;

  String _branchName;
  String get branchName => _branchName;

  Profile({
    required String userID,
    required String branchName,
  })  : _userID = userID,
        _branchName = branchName;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json["userID"].trim(),
      branchName: json["branchName"],
    );
  }
}
