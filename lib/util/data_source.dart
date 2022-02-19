import 'dart:io';

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
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Client _client = Get.find<Client>();
DataController _data = Get.find<DataController>();

// TODO: data_source -> controller 통합

Future<void> setTerms() async {
  final _today = DateTime.now();
  final _terms = await _client.getTerms(0);

  _data.currentTerm = []
    // this term
    ..add(_terms.lastWhere(
      (element) => element.termEnd.isAfter(_today),
      orElse: () => _terms.first,
    ))
    // last term
    ..add(_terms.firstWhere((element) => element.termEnd.isBefore(_today)));
  _data.terms = await _client.getTerms(10);
}

Future<void> getInitialForTeacherData() async {
  _data.teachers = await _client.getTeachers(
    teacherID: _data.profile.userID,
  );
  _data.branches = _data.teachers.map((e) => e.branchName).toSet().toList();

  _data.update();
}

Future<void> getReservationData({
  required DateTime displayDate,
  required String branchName,
  String? userID,
  String? teacherID,
}) async {
  final first = DateTime(displayDate.year, displayDate.month,
      displayDate.day - displayDate.weekday % 7);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _data.reservations = await _client.getReservations(
    branchName: branchName,
    teacherID: teacherID,
    startDate: first,
    endDate: last,
    userID: userID,
    bookingStatus: [-3, -1, 0, 1, 3],
  );

  _data.teacherInfos = await _client.getTeacherInfos(
    branchName: branchName,
  );

  var _teacherColors = Map<String, Color?>.fromIterable(
    _data.teacherInfos,
    key: (item) => item.teacherID,
    value: (item) => item.color,
  );

  var _teachers = await _client.getTeachers(
    teacherID: teacherID,
    branchName: branchName,
  );

  _data.reservationDataSource = ReservationDataSource();

  _data.timeRegions = [];
  await Future.forEach<Teacher>(_teachers, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: first.subtract(Duration(days: 7)).add(element.startTime),
      endTime: first.subtract(Duration(days: 7)).add(element.endTime),
      recurrenceRule:
          "FREQ=WEEKLY;INTERVAL=1;BYDAY=${element.workDowToString.substring(0, 2)};COUNT=3",
      color: _teacherColors[element.teacherID]?.withOpacity(0.2) ??
          symbolColor.withOpacity(0.2),
      resourceIds: [_teacherColors.keys.toList().indexOf(element.teacherID)],
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
      color: _teacherColors[element.teacherID]?.withOpacity(0.2) ??
          symbolColor.withOpacity(0.2),
      resourceIds: [_teacherColors.keys.toList().indexOf(element.teacherID)],
    ));
  });

  _data.update();
}

Future<void> getReservationForTeacherData() async {
  final displayDate = _data.displayDate;
  final teacherID = _data.profile.userID;

  final first = DateTime(displayDate.year, displayDate.month,
      displayDate.day - displayDate.weekday % 7);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  _data.teacherInfos = [
    TeacherInfo(teacherID: teacherID, color: symbolColor),
  ];

  _data.reservations = [];
  await Future.forEach<String>(_data.branches, (element) async {
    _data.reservations.addAll(await _client.getReservations(
      branchName: element,
      teacherID: teacherID,
      startDate: first,
      endDate: last,
      bookingStatus: [-3, -1, 0, 1, 3],
    ));
  });

  _data.reservationDataSource = ReservationDataSource();

  _data.timeRegions = [];
  await Future.forEach<Teacher>(_data.teachers, (element) async {
    _data.timeRegions.add(TimeRegion(
      startTime: first.subtract(Duration(days: 7)).add(element.startTime),
      endTime: first.subtract(Duration(days: 7)).add(element.endTime),
      recurrenceRule:
          "FREQ=WEEKLY;INTERVAL=1;BYDAY=${element.workDowToString.substring(0, 2)};COUNT=3",
      color: symbolColor.withOpacity(0.2),
      resourceIds: [0],
    ));
  });

  List<Control> _controls = [];
  await Future.forEach<String>(_data.branches, (element) async {
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
  String getSubject(int index) =>
      appointments![index].userID +
      "\n" +
      formatTimeRange(getStartTime(index), getEndTime(index));

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  List<Object> getResourceIds(int index) {
    var teacherIds = _data.teacherInfos.map((e) => e.teacherID).toList();

    return [teacherIds.indexOf(appointments![index].teacherID)];
  }
}

Future<void> getUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? userType,
  int? status,
  int? termID,
}) async {
  _data.users = await _client.getUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: userType,
    status: status,
    termID: termID,
  );
  _data.update();
}

Future<void> saveUsersData({
  String? branchName,
  String? userID,
  int? isPaid,
  int? userType,
  int? status,
  int? termID,
}) async {
  final userList = await _client.getUsers(
    branchName: branchName,
    userID: userID,
    isPaid: isPaid,
    userType: userType,
    status: status,
    termID: termID,
  )
    ..sort((a, b) => a.userName.compareTo(b.userName));

  final workbook = Workbook();
  final workSheet = workbook.worksheets[0];
  for (int i = 0; i < userList.length; i++) {
    workSheet.getRangeByName("A${i + 1}").setText(userList[i].userName);
    workSheet
        .getRangeByName("B${i + 1}")
        .setText(formatPhone(userList[i].userPhone));
  }
  workSheet.autoFitColumn(1);
  workSheet.autoFitColumn(2);

  final directory = Platform.isIOS
      ? await getApplicationDocumentsDirectory()
      : await getExternalStorageDirectory();
  final path = directory?.path;
  final fileName =
      "user_list_" + DateFormat("yyMMdd_HHmmss").format(DateTime.now());

  final bytes = workbook.saveAsStream();
  File("$path/$fileName.xlsx").writeAsBytesSync(bytes);
  File("$path/$fileName.xls").writeAsBytesSync(bytes);
  workbook.dispose();

  Get.snackbar(
    "",
    "",
    duration: const Duration(seconds: 10),
    titleText: Text(
      "유저 정보 목록 저장",
      style: TextStyle(color: Colors.white, fontSize: 24.r),
    ),
    messageText: Text(
      Platform.isIOS
          ? "파일/나의 iPhone(iPad)/솔바이올린(관리자)/$fileName.xlsx"
          : "내장 메모리/Android/data/com.solviolin.solviolin_admin/files/$fileName.xlsx",
      style: contentStyle,
    ),
  );
}

Future<void> getUserDetailData(User user) async {
  final today = DateTime.now();

  try {
    _data.regularSchedules =
        await _client.getRegularSchedulesByAdmin(user.userID);
  } on NetworkException catch (e) {
    // regular schedule not found
    if (e.response?.statusCode == 404) {
      _data.regularSchedules = [
        RegularSchedule(
          userID: user.userID,
          branchName: user.branchName,
        ),
      ];
    } else {
      rethrow;
    }
  }

  if (user.userType == 0) {
    _data.thisMonthReservations = await _client.getReservations(
      branchName: user.branchName,
      startDate: DateTime(today.year, today.month, 1),
      endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
      userID: user.userID,
      bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
    );

    _data.lastMonthReservations = await _client.getReservations(
      branchName: user.branchName,
      startDate: DateTime(today.year, today.month - 1, 1),
      endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
      userID: user.userID,
      bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
    );

    _data.changes = await _client.getChangesWithID(user.userID);

    _data.myLedgers = await _client.getLedgers(
      userID: user.userID,
    );
  } else {
    _data.thisMonthReservations = [];
    _data.lastMonthReservations = [];
    _data.changes = [];
    _data.myLedgers = [];

    if (user.userType == 1) {
      var _teacherInfos = await _client.getTeacherInfos(
        branchName: user.branchName,
      );
      var _teacherIds = _teacherInfos.map((e) => e.teacherID).toList();
      var _index = _teacherIds.indexOf(user.userID);

      var _search = Get.find<CacheController>(tag: "/search/user");
      _search.teacherColor = _index == -1 ? null : _teacherInfos[_index].color;
    }
  }

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
  );

  _data.update();
}

Future<void> getControlsForTeacherData({
  DateTime? controlStart,
  DateTime? controlEnd,
}) async {
  _data.controls = [];
  await Future.forEach<String>(_data.branches, (element) async {
    _data.controls.addAll(await _client.getControls(
      branchName: element,
      teacherID: _data.profile.userID,
      controlStart: controlStart,
      controlEnd: controlEnd,
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
  );

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
  );
  _data.update();
}
