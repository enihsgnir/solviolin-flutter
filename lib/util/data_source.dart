import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Client _client = Get.find<Client>();
DataController _controller = Get.find<DataController>();

extension RFS on num {
  double get r => this * _controller.ratio; //'r'esponsible font size
}

Color symbolColor = const Color.fromRGBO(96, 128, 104, 100);

Future<void> logoutAndDeleteData() async {
  await _client.logout();
}

Future<void> getInitialData([
  bool isLoggedIn = true,
  String? userID,
  String? userPassword,
]) async {
  if (isLoggedIn == true) {
    _controller.updateProfile(await _client.getProfile());
  } else {
    _controller.updateProfile(await _client.login(userID!, userPassword!));
  }

  _controller.updateCurrentTerm(await _client.getCurrentTerm()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));

  _controller.updateTerms(await _client.getTerms(10)
    ..sort((a, b) => b.termStart.compareTo(a.termStart)));

  _controller.updateBranches(await _client.getBranches()
    ..sort((a, b) => a.compareTo(b)));
}

Future<void> getReservationData({
  required DateTime displayDate,
  required String branchName,
  String? userID,
  String? teacherID,
}) async {
  final int weekday = displayDate.weekday % 7;
  final DateTime first =
      DateTime(displayDate.year, displayDate.month, displayDate.day - weekday);
  final DateTime last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _controller.updateTeacherInfos(await _client.getTeacherInfos(
    branchName: branchName,
  )
    ..sort((a, b) => a.teacherID.compareTo(b.teacherID)));

  _controller.updateReservations(await _client.getReservations(
    branchName: branchName,
    startDate: first,
    endDate: last,
    userID: userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  if (teacherID != null) {
    _controller.updateReservations([
      for (Reservation reservation in _controller.reservations)
        if (reservation.teacherID == teacherID) reservation
    ]);
  }

  _controller.updateReservationDataSource(ReservationDataSource());
}

Future<void> getReservationDataForTeacher({
  required DateTime displayDate,
  required String branchName,
  required String teacherID,
}) async {
  final int weekday = displayDate.weekday % 7;
  final DateTime first =
      DateTime(displayDate.year, displayDate.month, displayDate.day - weekday);
  final DateTime last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _controller.updateTeacherInfos(
    [TeacherInfo(teacherID: teacherID, color: symbolColor)],
  );

  _controller.updateReservations(await _client.getReservations(
    branchName: branchName,
    startDate: first,
    endDate: last,
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate))
    ..removeWhere((element) => element.teacherID != teacherID));

  _controller.updateReservationDataSource(ReservationDataSource());
}

bool isSameWeek(DateTime newDate, DateTime oldDate) {
  final int weekday = oldDate.weekday % 7;
  final DateTime first =
      DateTime(oldDate.year, oldDate.month, oldDate.day - weekday);
  final DateTime last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  return DateUtils.isSameDay(newDate, first) ||
      DateUtils.isSameDay(newDate, last) ||
      (newDate.isAfter(first) && newDate.isBefore(last));
}

class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource() {
    appointments = _controller.reservations;

    resources = List<CalendarResource>.generate(
      _controller.teacherInfos.length,
      (index) => CalendarResource(
        displayName: _controller.teacherInfos[index].teacherID,
        id: index,
        color: _controller.teacherInfos[index].color ?? Colors.transparent,
      ),
    );
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index].endDate;

  @override
  String getSubject(int index) {
    String start = DateFormat("HH:mm").format(appointments![index].startDate);
    String end = DateFormat("HH:mm").format(appointments![index].endDate);
    return appointments![index].userID + "\n$start ~ $end";
  }

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  List<Object> getResourceIds(int index) {
    List<String> teacherIDs = List<String>.generate(
      _controller.teacherInfos.length,
      (index) => _controller.teacherInfos[index].teacherID,
    );

    return [teacherIDs.indexOf(appointments![index].teacherID)];
  }
}

Future<void> getUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? status,
}) async {
  _controller.updateUsers(await _client.getUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: 0,
    status: status,
  )
    ..sort((a, b) => a.userID.compareTo(b.userID)));
}

Future<void> saveUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? status,
}) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File("$path/users_list.json");

  final List<dynamic> data = await _client.getRawUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: 0,
    status: status,
  );

  file.writeAsString(json.encode(data));

  Get.snackbar(
    "",
    "",
    titleText: Text(
      "유저 정보 목록 저장",
      style: TextStyle(color: Colors.white, fontSize: 24.r),
    ),
    messageText: Text(
      "$path/users_list.json",
      style: TextStyle(color: Colors.white, fontSize: 20.r),
    ),
  );
}

Future<void> getUserDetailData(User user) async {
  final DateTime today = DateTime.now();

  _controller.updateRegularSchedules(
      await _client.getRegularSchedulesByAdmin(user.userID)
        ..sort((a, b) {
          int primary = a.dow.compareTo(b.dow);
          return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
        }));

  _controller.updateThisMonthReservations(await _client.getReservations(
    branchName: user.branchName,
    startDate: DateTime(today.year, today.month, 1),
    endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
    userID: user.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateLastMonthReservations(await _client.getReservations(
    branchName: user.branchName,
    startDate: DateTime(today.year, today.month - 1, 1),
    endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
    userID: user.userID,
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateChanges(await _client.getChangesWithID(user.userID)
    ..sort((a, b) {
      int primary = a.fromDate.compareTo(b.fromDate);
      return primary != 0
          ? primary
          : a.toDate == null || b.toDate == null
              ? 0
              : a.toDate!.compareTo(b.toDate!);
    }));
}

Future<void> getControlsData({
  required String branchName,
  String? teacherID,
  DateTime? startDate,
  DateTime? endDate,
  int? status,
}) async {
  _controller.updateControls(await _client.getControls(
    branchName: branchName,
    teacherID: teacherID,
    startDate: startDate,
    endDate: endDate?.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
    status: status,
  )
    ..sort((a, b) => a.controlStart.compareTo(b.controlStart)));
}

Future<void> getTeachersData({
  String? teacherID,
  String? branchName,
}) async {
  _controller.updateTeachers(await _client.getTeachers(
    teacherID: teacherID,
    branchName: branchName,
  )
    ..sort((a, b) {
      int primary = a.teacherID.compareTo(b.teacherID);
      int secondary = a.workDow.compareTo(b.workDow);
      return primary != 0
          ? primary
          : secondary != 0
              ? secondary
              : a.startTime.compareTo(b.startTime);
    }));
}

Future<void> getLedgersData({
  required String branchName,
  required int termID,
  required String userID,
}) async {
  _controller.updateLedgers(await _client.getLedgers(
    branchName: branchName,
    termID: termID,
    userID: userID,
  )
    ..sort((a, b) {
      int primary = b.paidAt.compareTo(a.paidAt);
      return primary != 0 ? primary : a.userID.compareTo(b.userID);
    }));
}

// Implement with FutureBuilder not GetBuilder
Future<void> getTotalLedgerData({
  required String branchName,
  required int termID,
}) async {
  _controller.updateTotalLedger(await _client.getTotalLedger(
    branchName: branchName,
    termID: termID,
  ));
}
