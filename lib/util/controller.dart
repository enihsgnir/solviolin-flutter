import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/change.dart';
import 'package:solviolin/model/profile.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/term.dart';

class DataController extends GetxController {
  late final double ratio;

  late Profile profile;

  List<RegularSchedule> regularSchedules = [];
  List<DateTime> availabaleSpots = [];
  List<Reservation> myValidReservations = [];
  List<Term> currentTerm = [];

  DateTime selectedDay =
      DateUtils.dateOnly(DateTime.now()).add(DateTime.now().timeZoneOffset);
  DateTime focusedDay =
      DateUtils.dateOnly(DateTime.now()).add(DateTime.now().timeZoneOffset);

  List<Reservation> thisMonthReservations = [];
  List<Reservation> lastMonthReservations = [];
  List<Change> changes = [];

  bool isRegularScheduleExisting = true;

  void updateDays(DateTime selectedData, DateTime focusedData) {
    selectedDay = selectedData;
    focusedDay = focusedData;
    update();
  }

  void reset() {
    regularSchedules = [];
    availabaleSpots = [];
    myValidReservations = [];
    currentTerm = [];

    thisMonthReservations = [];
    lastMonthReservations = [];
    changes = [];
  }
}
