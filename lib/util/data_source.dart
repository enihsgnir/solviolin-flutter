import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Client _client = Get.put(Client());
DataController _controller = Get.find<DataController>();

Future<void> logoutAndDeleteData() async {
  await _client.logout();
}

Future<void> getInitialData({
  bool isLoggedIn = true,
  String? userID,
  String? userPassword,
}) async {
  if (isLoggedIn == true) {
    _controller.updateProfile(await _client.getProfile());
  } else {
    assert(userID != null && userPassword != null);
    _controller.updateProfile(await _client.login(userID!, userPassword!));
  }

  _controller.updateCurrentTerm(await _client.getCurrentTerm()
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));

  _controller.updateTerms(await _client.getTerms(10)
    ..sort((a, b) => b.termStart.compareTo(a.termStart)));

  _controller.updateBranches(await _client.getBranches()
    ..sort((a, b) => a.branchName.compareTo(b.branchName)));
}

Future<void> getReservationData({
  required DateTime focusedDay,
  required String branchName,
  String? userID,
  String? teacherID,
}) async {
  final DateTime first = DateTime(focusedDay.year, focusedDay.month, 1);
  final DateTime last = DateTime(focusedDay.year, focusedDay.month + 1, 0);

  _controller.updateTeacherName(await _client.getTeacherName(
    branchName: branchName,
  )
    ..sort((a, b) => a.compareTo(b)));

  _controller.updateReservations(await _client.getReservations(
    branchName: branchName,
    startDate: first,
    endDate: last.add(Duration(hours: 23, minutes: 59, seconds: 59)),
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

class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource() {
    appointments = _controller.reservations;

    resources = List<CalendarResource>.generate(
      _controller.teacherName.length,
      (index) => CalendarResource(
        displayName: _controller.teacherName[index],
        id: index,
        // color:
        //     Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8),
      ),
    );
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index]
      .endDate
      .add(Duration(minutes: appointments![index].extendedMin));

  @override
  String getSubject(int index) {
    String start = DateFormat("HH:mm").format(appointments![index].startDate);
    String end = DateFormat("HH:mm").format(appointments![index]
        .endDate
        .add(Duration(minutes: appointments![index].extendedMin)));
    return "$start ~ $end\n" + appointments![index].userID;
  }

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  List<Object> getResourceIds(int index) =>
      [_controller.teacherName.indexOf(appointments![index].teacherID)];
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
    status: status,
  )
    ..sort((a, b) => a.userID.compareTo(b.userID)));
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
      int primary = a.from.startDate.compareTo(b.from.startDate);
      return primary != 0
          ? primary
          : a.to == null || b.to == null
              ? 0
              : a.to!.startDate.compareTo(b.to!.startDate);
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

Future<void> getTermsData(int take) async {
  _controller.updateTerms(await _client.getTerms(take)
    ..sort((a, b) => a.termStart.compareTo(b.termStart)));
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

Future<void> getTotalLedgerData({
  required String branchName,
  required int termID,
}) async {
  _controller.updateTotalLedger(await _client.getTotalLedger(
    branchName: branchName,
    termID: termID,
  ));
}
