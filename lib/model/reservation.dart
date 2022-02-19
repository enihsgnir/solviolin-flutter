import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/format.dart';

class Reservation {
  int id;
  DateTime startDate;
  DateTime endDate;

  /// `0`: Regular, `1`: MadeUp, `2`: Canceled, `3`: Extended, Negative: By Admin
  int bookingStatus;
  String userID;
  String teacherID;
  String branchName;
  int? regularID;

  /// `RegExp(r"^#[0-9A-Fa-f]{6}$")`
  Color? color;

  Reservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.bookingStatus,
    required this.userID,
    required this.teacherID,
    required this.branchName,
    this.regularID,
    this.color,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json["id"],
      startDate: parseDateTime(json["startDate"]),
      endDate: parseDateTime(json["endDate"]),
      bookingStatus: json["bookingStatus"],
      userID: json["userID"].trim(),
      teacherID: json["teacherID"].trim(),
      branchName: json["branchName"],
      regularID: json["regularID"],
      color: parseColor(json["teacher"]["color"]),
    );
  }

  @override
  String toString() =>
      "$teacherID / $branchName\n" + formatDateTimeRange(startDate, endDate);

  String get statusToString =>
      {
        0: "정기",
        1: "보강",
        2: "취소",
        3: "연장",
        -1: "보강(관리자)",
        -2: "취소(관리자)",
        -3: "연장(관리자)",
      }[bookingStatus] ??
      "Null";
}
