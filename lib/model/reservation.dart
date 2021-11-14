import 'package:solviolin/util/format.dart';

class Reservation {
  int id;
  DateTime startDate;
  DateTime endDate;
  int bookingStatus;
  String teacherID;
  String branchName;

  Reservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.bookingStatus,
    required this.teacherID,
    required this.branchName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json["id"],
      startDate: parseDateTime(json["startDate"]),
      endDate: parseDateTime(json["endDate"]),
      bookingStatus: json["bookingStatus"],
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
    );
  }
}
