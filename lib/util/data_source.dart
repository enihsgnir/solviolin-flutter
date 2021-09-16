import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Client _client = Get.find<Client>();
DataController _data = Get.find<DataController>();

//TODO: remove some unnecessary functions

Future<void> getInitialData([
  bool isLoggedIn = true,
  String? userID,
  String? userPassword,
]) async {
  isLoggedIn
      ? _data.profile = await _client.getProfile()
      : _data.profile = await _client.login(userID!, userPassword!);

  _data.currentTerm = await _client.getCurrentTerm()
    ..sort((a, b) => a.termStart.compareTo(b.termStart));

  _data.terms = await _client.getTerms(10)
    ..sort((a, b) => b.termStart.compareTo(a.termStart));

  _data.branches = await _client.getBranches()
    ..sort((a, b) => a.compareTo(b));

  _data.update();
}

Future<void> getReservationData({
  required DateTime displayDate,
  required String branchName,
  String? userID,
  String? teacherID,
}) async {
  final weekday = displayDate.weekday % 7;
  final first =
      DateTime(displayDate.year, displayDate.month, displayDate.day - weekday);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _data.teacherInfos = await _client.getTeacherInfos(
    branchName: branchName,
  )
    ..sort((a, b) => a.teacherID.compareTo(b.teacherID));

  _data.reservations = await _client.getReservations(
    branchName: branchName,
    teacherID: teacherID,
    startDate: first,
    endDate: last,
    userID: userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate));

  _data.reservationDataSource = ReservationDataSource();

  _data.update();
}

Future<void> getReservationDataForTeacher({
  required DateTime displayDate,
  required String teacherID,
}) async {
  final weekday = displayDate.weekday % 7;
  final first =
      DateTime(displayDate.year, displayDate.month, displayDate.day - weekday);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _data.teacherInfos = [
    TeacherInfo(teacherID: teacherID, color: symbolColor),
  ];

  _data.teachers = await _client.getTeachers(
    teacherID: teacherID,
  );

  var _branches = List.generate(
    _data.teachers.length,
    (index) => _data.teachers[index].branchName,
  ).toSet().toList();

  List<Reservation> _reservations = [];
  await Future.forEach<String>(_branches, (element) async {
    _reservations.addAll(await _client.getReservations(
      branchName: element,
      teacherID: teacherID,
      startDate: first,
      endDate: last,
      bookingStatus: [-3, -1, 0, 1, 3],
    )
      ..sort((a, b) => a.startDate.compareTo(b.startDate)));
  });
  _data.reservations = _reservations;

  _data.reservationDataSource = ReservationDataSource();

  _data.update();
}

bool isSameWeek(DateTime newDate, DateTime oldDate) {
  final weekday = oldDate.weekday % 7;
  final first = DateTime(oldDate.year, oldDate.month, oldDate.day - weekday);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  return DateUtils.isSameDay(newDate, first) ||
      DateUtils.isSameDay(newDate, last) ||
      (newDate.isAfter(first) && newDate.isBefore(last));
}

class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource() {
    appointments = _data.reservations;

    resources = List.generate(
      _data.teacherInfos.length,
      (index) => CalendarResource(
        displayName: _data.teacherInfos[index].teacherID,
        id: index,
        color: _data.teacherInfos[index].color ?? Colors.transparent,
      ),
    )..add(CalendarResource(
        displayName: "Others",
        id: -1,
        color: Colors.transparent,
      ));
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index].endDate;

  @override
  String getSubject(int index) {
    final start = DateFormat("HH:mm").format(appointments![index].startDate);
    final end = DateFormat("HH:mm").format(appointments![index].endDate);

    return appointments![index].userID + "\n$start ~ $end";
  }

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  List<Object> getResourceIds(int index) {
    var teacherIDs = List.generate(
      _data.teacherInfos.length,
      (index) => _data.teacherInfos[index].teacherID,
    );

    return [teacherIDs.indexOf(appointments![index].teacherID)];
  }
}

Future<void> getUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? userType,
  int? status,
}) async {
  _data.users = await _client.getUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: userType,
    status: status,
  )
    ..sort((a, b) => a.userID.compareTo(b.userID));
  _data.update();
}

Future<void> saveUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? userType,
  int? status,
}) async {
  final directory = Platform.isIOS
      ? await getApplicationDocumentsDirectory()
      : await getExternalStorageDirectory();
  final path = directory?.path;
  final file = File("$path/users_list_" +
      "${DateFormat("yy_MM_dd_HH_mm").format(DateTime.now())}.json");

  final data = await _client.getJsonUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: userType,
    status: status,
  );
  file.writeAsString(json.encode(data));

  Get.snackbar(
    "",
    "",
    duration: const Duration(seconds: 10),
    titleText: Text(
      "유저 정보 목록 저장",
      style: TextStyle(color: Colors.white, fontSize: 24.r),
    ),
    messageText: Text(file.path, style: contentStyle),
  );
}

Future<void> getUserDetailData(User user) async {
  final today = DateTime.now();

  try {
    _data.regularSchedules =
        await _client.getRegularSchedulesByAdmin(user.userID)
          ..sort((a, b) {
            var primary = a.dow.compareTo(b.dow);

            return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
          });
  } catch (_) {
    _data.regularSchedules = [
      RegularSchedule(
        id: -1,
        startTime: const Duration(hours: 0, minutes: 0),
        endTime: const Duration(hours: 0, minutes: 0),
        dow: -1,
        userID: user.userID,
        teacherID: "Null",
        branchName: user.branchName,
      )
    ];
  }

  _data.thisMonthReservations = await _client.getReservations(
    branchName: user.branchName,
    startDate: DateTime(today.year, today.month, 1),
    endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
    userID: user.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate));

  _data.lastMonthReservations = await _client.getReservations(
    branchName: user.branchName,
    startDate: DateTime(today.year, today.month - 1, 1),
    endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
    userID: user.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate));

  _data.changes = await _client.getChangesWithID(user.userID)
    ..sort((a, b) {
      var primary = a.fromDate.compareTo(b.fromDate);

      return primary != 0
          ? primary
          : a.toDate == null || b.toDate == null
              ? 0
              : a.toDate!.compareTo(b.toDate!);
    });

  _data.update();
}

Future<void> getControlsData({
  required String branchName,
  String? teacherID,
  DateTime? startDate,
  DateTime? endDate,
  int? status,
}) async {
  _data.controls = await _client.getControls(
    branchName: branchName,
    teacherID: teacherID,
    startDate: startDate,
    endDate: endDate?.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
    status: status,
  )
    ..sort((a, b) => a.controlStart.compareTo(b.controlStart));

  _data.update();
}

Future<void> getTeachersData({
  String? teacherID,
  String? branchName,
}) async {
  _data.teachers = await _client.getTeachers(
    teacherID: teacherID,
    branchName: branchName,
  )
    ..sort((a, b) {
      var primary = a.teacherID.compareTo(b.teacherID);
      var secondary = a.workDow.compareTo(b.workDow);

      return primary != 0
          ? primary
          : secondary != 0
              ? secondary
              : a.startTime.compareTo(b.startTime);
    });

  _data.update();
}

Future<void> getLedgersData({
  String? branchName,
  int? termID,
  String? userID,
}) async {
  _data.ledgers = await _client.getLedgers(
    branchName: branchName,
    termID: termID,
    userID: userID,
  )
    ..sort((a, b) {
      var primary = b.paidAt.compareTo(a.paidAt);

      return primary != 0 ? primary : a.userID.compareTo(b.userID);
    });
  _data.update();
}
