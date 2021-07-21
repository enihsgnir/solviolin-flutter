class Verification {
  String userID;
  String code;
  String? verifiedAt;
  String issuedAt;

  Verification({
    required this.userID,
    required this.code,
    this.verifiedAt,
    required this.issuedAt,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      userID: json["userID"],
      code: json["code"],
      verifiedAt: json["verifiedAt"],
      issuedAt: json["issuedAt"],
    );
  }
}
