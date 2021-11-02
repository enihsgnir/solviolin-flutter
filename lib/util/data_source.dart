import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Client _client = Get.find<Client>();
DataController _data = Get.find<DataController>();

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
  var teacherIds = List.generate(
    _data.teacherInfos.length,
    (index) => _data.teacherInfos[index].teacherID,
  );
  var teacherColors = Map<String, Color?>.fromIterable(
    _data.teacherInfos,
    key: (item) => item.teacherID,
    value: (item) => item.color,
  );

  _data.teachers = await _client.getTeachers(
    teacherID: teacherID,
    branchName: branchName,
  );

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

  _data.timeRegions = [];
  await Future.forEach<Teacher>(_data.teachers, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: first.subtract(Duration(days: 7)).add(element.startTime),
      endTime: first.subtract(Duration(days: 7)).add(element.endTime),
      recurrenceRule:
          "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToString(element.workDow).substring(0, 2)};COUNT=3",
      color: teacherColors[element.teacherID]?.withOpacity(0.2) ??
          symbolColor.withOpacity(0.2),
      resourceIds: [teacherIds.indexOf(element.teacherID)],
    ));
  });

  List<Control> _controls = await _client.getControls(
    branchName: branchName,
    teacherID: teacherID,
    controlStart: first,
    controlEnd: last,
    status: 0,
  );
  await Future.forEach<Control>(_controls, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: element.controlStart,
      endTime: element.controlEnd,
      color: teacherColors[element.teacherID]?.withOpacity(0.2) ??
          symbolColor.withOpacity(0.2),
      resourceIds: [teacherIds.indexOf(element.teacherID)],
    ));
  });

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

  _data.reservations = [];
  await Future.forEach<String>(_branches, (element) async {
    _data.reservations.addAll(await _client.getReservations(
      branchName: element,
      teacherID: teacherID,
      startDate: first,
      endDate: last,
      bookingStatus: [-3, -1, 0, 1, 3],
    )
      ..sort((a, b) => a.startDate.compareTo(b.startDate)));
  });

  _data.reservationDataSource = ReservationDataSource();

  _data.timeRegions = [];
  await Future.forEach<Teacher>(_data.teachers, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: first.subtract(Duration(days: 7)).add(element.startTime),
      endTime: first.subtract(Duration(days: 7)).add(element.endTime),
      recurrenceRule:
          "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToString(element.workDow).substring(0, 2)};COUNT=3",
      color: symbolColor.withOpacity(0.2),
      resourceIds: [0],
    ));
  });

  List<Control> _controls = [];
  await Future.forEach<String>(_branches, (element) async {
    _controls.addAll(await _client.getControls(
      branchName: element,
      teacherID: teacherID,
      controlStart: first,
      controlEnd: last,
      status: 0,
    ));
  });
  await Future.forEach<Control>(_controls, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: element.controlStart,
      endTime: element.controlEnd,
      color: symbolColor.withOpacity(0.2),
      resourceIds: [0],
    ));
  });

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
    var teacherIds = List.generate(
      _data.teacherInfos.length,
      (index) => _data.teacherInfos[index].teacherID,
    );

    return [teacherIds.indexOf(appointments![index].teacherID)];
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
  final jsonList = await _client.getJsonUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: userType,
    status: status,
  )
    ..sort((a, b) => a["userName"].compareTo(b["userName"]));

  var excel = Excel.createExcel();
  var sheetObject = excel["Sheet1"];
  for (int i = 0; i < jsonList.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
        .value = jsonList[i]["userName"];

    String phone = jsonList[i]["userPhone"];
    if (phone.length == 11) {
      phone = phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d{4})(\d+)"),
        (match) => "${match[1]}-${match[2]}-${match[3]}",
      );
    } else if (phone.length == 10) {
      phone = phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d{3})(\d+)"),
        (match) => "${match[1]}-${match[2]}-${match[3]}",
      );
    }
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
        .value = phone;
  }

  final directory = Platform.isIOS
      ? await getApplicationDocumentsDirectory()
      : await getExternalStorageDirectory();
  final path = directory?.path;
  final file = File("$path/user_list_" +
      "${DateFormat("yyMMdd_HHmmss").format(DateTime.now())}.xlsx")
    ..writeAsBytesSync(excel.encode()!);

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

  _data.myLedgers = await _client.getLedgers(
    userID: user.userID,
  )
    ..sort((a, b) => b.paidAt.compareTo(a.paidAt));

  _data.update();
}

Future<void> getControlsData({
  required String branchName,
  String? teacherID,
  DateTime? controlStart,
  DateTime? controlEnd,
  int? status,
}) async {
  _data.controls = await _client.getControls(
    branchName: branchName,
    teacherID: teacherID,
    controlStart: controlStart,
    controlEnd:
        controlEnd?.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
    status: status,
  )
    ..sort((a, b) => b.controlStart.compareTo(a.controlStart));

  _data.update();
}

Future<void> getControlsDataForTeacher({
  String? teacherID,
}) async {
  _data.teachers = await _client.getTeachers(
    teacherID: teacherID,
  );

  var _branches = List.generate(
    _data.teachers.length,
    (index) => _data.teachers[index].branchName,
  ).toSet().toList();

  _data.controls = []; //TODO: set contolStart and controlEnd
  await Future.forEach<String>(_branches, (element) async {
    _data.controls.addAll(await _client.getControls(
      branchName: element,
      teacherID: teacherID,
    ));
  });
  _data.controls.sort((a, b) => b.controlStart.compareTo(a.controlStart));

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
