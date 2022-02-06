import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/network.dart';
import 'package:table_calendar/table_calendar.dart';

Client _client = Get.find<Client>();
DataController _data = Get.find<DataController>();

int _getFirstDayOffset(DateTime date) {
  final weekdayFromMonday = DateTime(date.year, date.month).weekday - 1;
  var firstDayOfWeekIndex = 0;
  firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

  return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
}

Future<void> getInitialData([
  bool isLoggedIn = true,
  String? userID,
  String? userPassword,
  bool? autoLogin,
]) async {
  // final today = DateTime.now();
  // final first = DateTime(today.year, today.month, 1)
  //     .subtract(Duration(days: _getFirstDayOffset(today)));
  // final last = DateTime(today.year, today.month + 1, 0, 23, 59, 59).add(
  //     Duration(
  //         days:
  //             14 - _getFirstDayOffset(DateTime(today.year, today.month + 1))));

  _data.profile = isLoggedIn
      ? await _client.getProfile()
      : await _client.login(userID!, userPassword!, autoLogin!);

  try {
    _data.regularSchedules = await _client.getRegularSchedules();
    _data.isRegularScheduleExisting = true;
  } catch (e) {
    _data.regularSchedules = [
      RegularSchedule(
        startTime: const Duration(),
        endTime: const Duration(),
        dow: -1,
        teacherID: "Null",
        branchName: _data.profile.branchName,
      ),
    ];
    _data.isRegularScheduleExisting = false;
  }

  // _data.availabaleSpots = !_data.isRegularScheduleExisting
  //     ? []
  //     : await _client.getAvailableSpots(
  //         branchName: _data.profile.branchName,
  //         teacherID: _data.regularSchedules[0].teacherID,
  //         startDate: DateTime.utc(today.year, today.month, today.day),
  //       )
  //   ..removeWhere((element) =>
  //       Duration(hours: element.hour, minutes: element.minute) <=
  //       Duration(hours: today.hour + 4, minutes: today.minute))
  //   ..removeWhere((element) {
  //     var regular = _data.regularSchedules[0];
  //     return regular.dow >= 1 &&
  //         regular.dow <= 5 &&
  //         regular.startTime.inHours < 16 &&
  //         element.hour >= 16;
  //   });

  // _data.myValidReservations = await _client.getReservations(
  //   branchName: _data.profile.branchName,
  //   startDate: first,
  //   endDate: last,
  //   userID: _data.profile.userID,
  //   bookingStatus: [-3, -1, 0, 1, 3],
  // );

  _data.currentTerm = await _client.getCurrentTerm();
  _data.update();
}

// TODO: getInitialData와 동일
Future<void> getUserBasedData() async {
  _data.profile = await _client.getProfile();

  try {
    _data.regularSchedules = await _client.getRegularSchedules();
    _data.isRegularScheduleExisting = true;
  } catch (e) {
    _data.regularSchedules = [
      RegularSchedule(
        startTime: const Duration(),
        endTime: const Duration(),
        dow: -1,
        teacherID: "Null",
        branchName: _data.profile.branchName,
      ),
    ];
    _data.isRegularScheduleExisting = false;
  }

  _data.currentTerm = await _client.getCurrentTerm();
  _data.update();
}

Future<void> getSelectedDayData(DateTime selectedDay) async {
  final today = DateTime.now();

  _data.availabaleSpots = !_data.isRegularScheduleExisting
      ? []
      : await _client.getAvailableSpots(
          branchName: _data.profile.branchName,
          teacherID: _data.regularSchedules[0].teacherID,
          startDate: selectedDay,
        )
    ..removeWhere((element) => isSameDay(selectedDay, today)
        ? Duration(hours: element.hour, minutes: element.minute) <=
            Duration(hours: today.hour + 4, minutes: today.minute)
        : false)
    ..removeWhere((element) {
      var regular = _data.regularSchedules[0];
      return regular.dow >= 1 &&
          regular.dow <= 5 &&
          regular.startTime.inHours < 16 &&
          element.hour >= 16;
    });
  _data.update();
}

Future<void> getChangedPageData(DateTime focusedDay) async {
  final first = DateTime(focusedDay.year, focusedDay.month, 1)
      .subtract(Duration(days: _getFirstDayOffset(focusedDay)));
  final last = DateTime(focusedDay.year, focusedDay.month + 1, 0, 23, 59, 59)
      .add(Duration(
          days: 14 -
              _getFirstDayOffset(
                  DateTime(focusedDay.year, focusedDay.month + 1))));

  _data.myValidReservations = await _client.getReservations(
    branchName: _data.profile.branchName,
    startDate: first,
    endDate: last,
    userID: _data.profile.userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  );
  _data.update();
}

Future<void> getReservedHistoryData() async {
  final today = DateTime.now();

  var _terms = await _client.getTerms(0);
  var _lastTerm =
      _terms.firstWhere((element) => element.termEnd.isBefore(today));
  print(_lastTerm.termEnd);

  // TODO: currentTerm[0] 기준
  _data.thisMonthReservations = await _client.getReservations(
    branchName: _data.profile.branchName,
    startDate: DateTime(today.year, today.month, 1),
    endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
    userID: _data.profile.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  );

  // TODO: _lastTerm 기준
  // TODO: 그냥 currentTerm도 찾아서 쓸까
  _data.lastMonthReservations = await _client.getReservations(
    branchName: _data.profile.branchName,
    startDate: DateTime(today.year, today.month - 1, 1),
    endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
    userID: _data.profile.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  );

  _data.changes = await _client.getChanges();
  _data.update();
}

// CalendarReserved DataSource
//
extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (map, element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

Map<DateTime, List<Reservation>> getEventSource() =>
    _data.myValidReservations.groupBy((reservation) {
      var date = reservation.startDate;
      return DateTime(date.year, date.month, date.day);
    });

LinkedHashMap<DateTime, List<Reservation>> getEvents() => LinkedHashMap(
      equals: isSameDay,
      hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(getEventSource());
