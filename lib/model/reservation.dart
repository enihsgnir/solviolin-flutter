import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/format.dart';

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
  Color? color;

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
    this.color,
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
      color: Color(int.parse(
        "FF" + json["teacher"]["color"].substring(1),
        radix: 16,
      )),
    );
  }
}
