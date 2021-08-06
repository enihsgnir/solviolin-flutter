import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/network.dart';
import 'package:table_calendar/table_calendar.dart';

Future<void> getInitialData({bool isLoggedIn = true}) async {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  final DateTime first = DateTime(kToday.year, kToday.month, 1);
  final DateTime last = DateTime(kToday.year, kToday.month + 1, 0);

  if (isLoggedIn == true) {
    controller.updateUser(await client.getProfile());
  }

  controller.updateRegularSchedules(await client.getRegularSchedules()
    ..sort((a, b) {
      int primary = a.dow.compareTo(b.dow);
      return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
    }));

  controller.updateAvailableSpots(await client.getAvailableSpots(
    branchName: controller.user.branchName,
    teacherID: controller.regularSchedules[0].teacherID,
    startDate: DateTime(kToday.year, kToday.month, kToday.day),
  )
    ..sort((a, b) => a.compareTo(b)));

  controller.updateMyValidReservations(await client.getReservations(
    branchName: controller.user.branchName,
    startDate: first,
    endDate: last.add(Duration(hours: 23, minutes: 59, seconds: 59)),
    userID: "sleep",
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  controller.updateCurrentTerms(await client.getCurrentTerms()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));
}

Future<void> getUserBasedData() async {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  controller.updateUser(await client.getProfile());

  controller.updateRegularSchedules(await client.getRegularSchedules()
    ..sort((a, b) {
      int primary = a.dow.compareTo(b.dow);
      return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
    }));

  controller.updateCurrentTerms(await client.getCurrentTerms()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));
}

Future<void> getSelectedDayData(DateTime selectedDay) async {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  controller.updateAvailableSpots(await client.getAvailableSpots(
    branchName: controller.user.branchName,
    teacherID: controller.regularSchedules[0].teacherID,
    startDate: selectedDay,
  )
    ..sort((a, b) => a.compareTo(b)));
}

Future<void> getChangedPageData(DateTime focusedDay) async {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  final DateTime first = DateTime(focusedDay.year, focusedDay.month, 1);
  final DateTime last = DateTime(focusedDay.year, focusedDay.month + 1, 0);

  controller.updateMyValidReservations(await client.getReservations(
    branchName: controller.user.branchName,
    startDate: first,
    endDate: last.add(Duration(hours: 23, minutes: 59, seconds: 59)),
    userID: "sleep",
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));
}

Future<void> getReservedHistoryData() async {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  controller.updateThisMonthReservations(await client.getReservations(
    branchName: controller.user.branchName,
    startDate: DateTime(kToday.year, kToday.month, 1),
    endDate: DateTime(kToday.year, kToday.month + 1, 0, 23, 59, 59),
    userID: "sleep",
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  controller.updateLastMonthReservations(await client.getReservations(
    branchName: controller.user.branchName,
    startDate: DateTime(kToday.year, kToday.month - 1, 1),
    endDate: DateTime(kToday.year, kToday.month, 0, 23, 59, 59),
    userID: "sleep",
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  controller.updateChanges(await client.getChanges()
    ..sort((a, b) {
      int primary = a.from.startDate.compareTo(b.from.startDate);
      return primary != 0
          ? primary
          : a.to == null || b.to == null
              ? 0
              : a.to!.startDate.compareTo(b.to!.startDate);
    }));
}

//CalendarReserved DataSource
//
extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

LinkedHashMap<DateTime, List<Reservation>> getEvents() =>
    LinkedHashMap<DateTime, List<Reservation>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(getEventSource());

Map<DateTime, List<Reservation>> getEventSource() =>
    Get.find<DataController>().myValidReservations.groupBy((reservation) {
      DateTime date = reservation.startDate;
      return DateTime(date.year, date.month, date.day);
    });

int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
