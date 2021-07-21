class Control {
  int id;
  DateTime controlStart;
  DateTime controlEnd;
  String teacherID;
  String branchName;
  int status;

  Control({
    required this.id,
    required this.controlStart,
    required this.controlEnd,
    required this.teacherID,
    required this.branchName,
    required this.status,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json["id"],
      controlStart: DateTime.parse(json["controlStart"]),
      controlEnd: DateTime.parse(json["controlEnd"]),
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      status: json["status"],
    );
  }
}
