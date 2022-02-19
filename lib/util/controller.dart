import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/change.dart';
import 'package:solviolin/model/profile.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/term.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:table_calendar/table_calendar.dart';

class DataController extends GetxController {
  var _client = Get.find<Client>();

  double _ratio = 1.0;
  bool _isRatioUpdated = false;

  static const double _kTestEnvWidth = 540;
  static const double _kTestEnvHeight = 1152;

  double get ratio => _ratio;

  /// set `_ratio`
  set size(Size size) {
    var _r = min(size.width / _kTestEnvWidth, size.height / _kTestEnvHeight);
    if (!_isRatioUpdated && _r != 0.0) {
      _ratio = _r;
      _isRatioUpdated = true;
      update();
    }
  }

  late Profile profile;

  List<RegularSchedule> regularSchedules = [];
  List<DateTime> availabaleSpots = [];
  List<Reservation> myValidReservations = [];

  /// `[0]`: this term, `[1]`: last term
  List<Term> currentTerm = [];

  DateTime selectedDay = DateTime.now().midnight;
  DateTime focusedDay = DateTime.now().midnight;

  List<Reservation> thisMonthReservations = [];
  List<Reservation> lastMonthReservations = [];
  List<Change> changes = [];

  bool _isRegularScheduleExisting = true;
  bool get isRegularScheduleExisting => _isRegularScheduleExisting;

  void reset() {
    regularSchedules = [];
    availabaleSpots = [];
    myValidReservations = [];
    currentTerm = [];

    thisMonthReservations = [];
    lastMonthReservations = [];
    changes = [];
  }

  Future<void> setTerms() async {
    var _today = DateTime.now();
    var _terms = await _client.getTerms(0);

    currentTerm = []
      // this term
      ..add(_terms.lastWhere(
        (element) => element.termEnd.isAfter(_today),
        orElse: () => _terms.first,
      ))
      // last term
      ..add(_terms.firstWhere((element) => element.termEnd.isBefore(_today)));
  }

  void setDays(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    update();
  }

  Future<void> getInitialData() async {
    try {
      regularSchedules = await _client.getRegularSchedules();
      _isRegularScheduleExisting = true;
    } on NetworkException catch (e) {
      // regular schedule not found
      if (e.response?.statusCode == 404) {
        regularSchedules = [
          RegularSchedule(branchName: profile.branchName),
        ];
        _isRegularScheduleExisting = false;
      } else {
        rethrow;
      }
    }

    update();
  }

  /// `selected`: by UTC
  Future<void> getSelectedDayData(DateTime selected) async {
    var _today = DateTime.now();

    availabaleSpots = !_isRegularScheduleExisting
        ? []
        : await _client.getAvailableSpots(
            branchName: profile.branchName,
            teacherID: regularSchedules[0].teacherID,
            startDate: selected,
          )
      ..removeWhere((element) => isSameDay(selected, _today)
          ? Duration(hours: element.hour, minutes: element.minute) <=
              Duration(hours: _today.hour + 4, minutes: _today.minute)
          : false)
      ..removeWhere((element) {
        var regular = regularSchedules[0];
        return regular.dow >= 1 &&
            regular.dow <= 5 &&
            regular.startTime.inHours < 16 &&
            element.hour >= 16;
      });

    update();
  }

  Future<void> getChangedPageData(DateTime focused) async {
    var _firstDay = DateTime(focused.year, focused.month);
    var _start = _firstDay.subtract(Duration(days: _firstDay.weekday % 7));
    var _end = _start.add(Duration(days: 42)).subtract(Duration(seconds: 1));

    myValidReservations = await _client.getReservations(
      branchName: profile.branchName,
      startDate: _start,
      endDate: _end,
      userID: profile.userID,
      bookingStatus: [-3, -1, 0, 1, 3],
    );

    update();
  }

  Future<void> getReservedHistoryData() async {
    thisMonthReservations = await _client.getReservations(
      branchName: profile.branchName,
      startDate: currentTerm[0].termStart,
      endDate: currentTerm[0].termEnd,
      userID: profile.userID,
      bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
    );

    lastMonthReservations = await _client.getReservations(
      branchName: profile.branchName,
      startDate: currentTerm[1].termStart,
      endDate: currentTerm[1].termEnd,
      userID: profile.userID,
      bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
    );

    changes = await _client.getChanges();

    update();
  }
}
