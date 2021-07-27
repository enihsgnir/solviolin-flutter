class Branch {
  String branchName;

  Branch({
    required this.branchName,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchName: json["branchName"],
    );
  }
}
