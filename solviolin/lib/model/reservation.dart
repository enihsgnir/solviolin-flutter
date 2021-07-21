class Reservation {
  int id;
  DateTime startDate;
  DateTime endDate;
  int bookingStatus;
  int extendedMin;
  String userID;
  String teacherID;
  String branchName;
  int? regularID;

  Reservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.bookingStatus,
    required this.extendedMin,
    required this.userID,
    required this.teacherID,
    required this.branchName,
    this.regularID,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json["id"],
      startDate: DateTime.parse(json["startDate"]),
      endDate: DateTime.parse(json["endDate"]),
      bookingStatus: json["bookingStatus"],
      extendedMin: json["extendedMin"],
      userID: json["userID"],
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      regularID: json["regularID"],
    );
  }

  @override
  bool operator ==(Object other) => other is Reservation && other.id == this.id;

  @override
  int get hashCode => this.id;

  @override
  String toString() => "${this.branchName} ${this.userID}\'s Reservation";
}
