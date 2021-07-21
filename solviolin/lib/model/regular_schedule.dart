class RegularSchedule {
  int id;
  String startTime;
  String endTime;
  int dow;
  DateTime startDate;
  DateTime endDate;
  String userID;
  String teacherID;
  String branchName;
  int termID;

  RegularSchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.dow,
    required this.startDate,
    required this.endDate,
    required this.userID,
    required this.teacherID,
    required this.branchName,
    required this.termID,
  });

  factory RegularSchedule.fromJson(Map<String, dynamic> json) {
    return RegularSchedule(
      id: json["id"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      dow: json["dow"],
      startDate: DateTime.parse(json["startDate"]),
      endDate: DateTime.parse(json["endDate"]),
      userID: json["userID"],
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      termID: json["termID"],
    );
  }
}
