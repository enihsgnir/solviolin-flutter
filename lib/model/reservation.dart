import 'package:solviolin/util/format.dart';

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
  int isControlled;

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
    required this.isControlled,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json["id"],
      startDate: parseDateTime(json["startDate"]),
      endDate: parseDateTime(json["endDate"]),
      bookingStatus: json["bookingStatus"],
      extendedMin: json["extendedMin"],
      userID: json["userID"],
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      regularID: json["regularID"],
      isControlled: json["isControlled"],
    );
  }
}
