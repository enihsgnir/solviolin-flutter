import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/network.dart';
import 'package:table_calendar/table_calendar.dart';

Client _client = Get.find<Client>();
DataController _controller = Get.find<DataController>();

//TODO: remove some unnecessary functions

Future<void> getInitialData([
  bool isLoggedIn = true,
  String? userID,
  String? userPassword,
]) async {
  final today = DateTime.now();
  final first = DateTime(today.year, today.month, 1);
  final last = DateTime(today.year, today.month + 1, 0);

  isLoggedIn
      ? _controller.updateProfile(await _client.getProfile())
      : _controller.updateProfile(await _client.login(userID!, userPassword!));

  try {
    _controller.updateRegularSchedules(await _client.getRegularSchedules()
      ..sort((a, b) {
        var primary = a.dow.compareTo(b.dow);

        return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
      }));
  } catch (e) {
    _controller.updateRegularSchedules([
      RegularSchedule(
        startTime: const Duration(hours: 0, minutes: 0),
        endTime: const Duration(hours: 0, minutes: 0),
        dow: -1,
        teacherID: "Null",
        branchName: _controller.profile.branchName,
      )
    ]);
  }

  _controller.updateAvailableSpots(await _client.getAvailableSpots(
    branchName: _controller.profile.branchName,
    teacherID: _controller.regularSchedules[0].teacherID,
    startDate: DateTime(today.year, today.month, today.day),
  )
    ..sort((a, b) => a.compareTo(b)));

  _controller.updateMyValidReservations(await _client.getReservations(
    branchName: _controller.profile.branchName,
    startDate: first,
    endDate: last.add(Duration(hours: 23, minutes: 59, seconds: 59)),
    userID: _controller.profile.userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateCurrentTerm(await _client.getCurrentTerm()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));
}

Future<void> getUserBasedData() async {
  _controller.updateProfile(await _client.getProfile());

  try {
    _controller.updateRegularSchedules(await _client.getRegularSchedules()
      ..sort((a, b) {
        var primary = a.dow.compareTo(b.dow);

        return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
      }));
  } catch (e) {
    _controller.updateRegularSchedules([
      RegularSchedule(
        startTime: const Duration(hours: 0, minutes: 0),
        endTime: const Duration(hours: 0, minutes: 0),
        dow: -1,
        teacherID: "Null",
        branchName: _controller.profile.branchName,
      )
    ]);
  }

  _controller.updateCurrentTerm(await _client.getCurrentTerm()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));
}

Future<void> getSelectedDayData(DateTime selectedDay) async {
  _controller.updateAvailableSpots(await _client.getAvailableSpots(
    branchName: _controller.profile.branchName,
    teacherID: _controller.regularSchedules[0].teacherID,
    startDate: selectedDay,
  )
    ..sort((a, b) => a.compareTo(b)));
}

Future<void> getChangedPageData(DateTime focusedDay) async {
  final first = DateTime(focusedDay.year, focusedDay.month, 1);
  final last = DateTime(focusedDay.year, focusedDay.month + 1, 0);

  _controller.updateMyValidReservations(await _client.getReservations(
    branchName: _controller.profile.branchName,
    startDate: first,
    endDate: last.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
    userID: _controller.profile.userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));
}

Future<void> getReservedHistoryData() async {
  final today = DateTime.now();

  _controller.updateThisMonthReservations(await _client.getReservations(
    branchName: _controller.profile.branchName,
    startDate: DateTime(today.year, today.month, 1),
    endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
    userID: _controller.profile.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateLastMonthReservations(await _client.getReservations(
    branchName: _controller.profile.branchName,
    startDate: DateTime(today.year, today.month - 1, 1),
    endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
    userID: _controller.profile.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateChanges(await _client.getChanges()
    ..sort((a, b) {
      var primary = a.fromDate.compareTo(b.fromDate);

      return primary != 0
          ? primary
          : a.toDate == null || b.toDate == null
              ? 0
              : a.toDate!.compareTo(b.toDate!);
    }));
}

//CalendarReserved DataSource
//
extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (map, element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

Map<DateTime, List<Reservation>> getEventSource() =>
    _controller.myValidReservations.groupBy((reservation) {
      var date = reservation.startDate;

      return DateTime(date.year, date.month, date.day);
    });

LinkedHashMap<DateTime, List<Reservation>> getEvents() => LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(getEventSource());

int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
