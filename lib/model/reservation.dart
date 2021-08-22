import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/format.dart';

class Reservation {
  int id;
  DateTime startDate;
  DateTime endDate;
  int bookingStatus;
  String userID;
  String teacherID;
  String branchName;
  Color? color;

  Reservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.bookingStatus,
    required this.userID,
    required this.teacherID,
    required this.branchName,
    this.color,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json["id"],
      startDate: parseDateTime(json["startDate"]),
      endDate: parseDateTime(json["endDate"]),
      bookingStatus: json["bookingStatus"],
      userID: json["userID"],
      teacherID: json["teacherID"],
      branchName: json["branchName"],
      color: json["teacher"]["color"] == null
          ? null
          : Color(int.parse(
              "FF" + json["teacher"]["color"].substring(1),
              radix: 16,
            )),
    );
  }
}
