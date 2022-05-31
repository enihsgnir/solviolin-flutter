import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solviolin_admin/model/canceled.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/model/check_in.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/profile.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/salary.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

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

  List<Term> currentTerm = [];
  List<Term> terms = [];
  List<String> branches = [];

  DateTime displayDate = DateTime.now().midnight;

  List<TeacherInfo> teacherInfos = [];
  List<Reservation> reservations = [];
  ReservationDataSource? reservationDataSource;
  List<TimeRegion> timeRegions = [];

  List<User> users = [];
  List<RegularSchedule> regularSchedules = [];
  List<Reservation> thisMonthReservations = [];
  List<Reservation> lastMonthReservations = [];
  List<Change> changes = [];
  List<Ledger> myLedgers = [];

  List<Control> controls = [];
  List<Teacher> teachers = [];
  List<Canceled> canceledReservations = [];
  List<Salary> salaries = [];
  List<Ledger> ledgers = [];
  String totalLeger = "";
  List<CheckIn> checkInHistories = [];

  void reset() {
    teacherInfos = [];
    reservations = [];
    reservationDataSource = null;

    users = [];
    regularSchedules = [];
    thisMonthReservations = [];
    lastMonthReservations = [];
    changes = [];
    myLedgers = [];

    controls = [];
    teachers = [];
    canceledReservations = [];
    salaries = [];
    ledgers = [];
    totalLeger = "";
    checkInHistories = [];
  }

  void updateDisplayDate(DateTime data) {
    displayDate = data;
    update();
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
    terms = await _client.getTerms(10);
  }

  Future<void> getInitialForTeacherData() async {
    teachers = await _client.getTeachers(
      teacherID: profile.userID,
    );
    branches = teachers.map((e) => e.branchName).toSet().toList();

    update();
  }

  Future<void> getReservationData({
    required String branchName,
    String? userID,
    String? teacherID,
  }) async {
    var first = DateTime(displayDate.year, displayDate.month,
        displayDate.day - displayDate.weekday % 7);
    var last =
        first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    reservations = await _client.getReservations(
      branchName: branchName,
      teacherID: teacherID,
      startDate: first,
      endDate: last,
      userID: userID,
      bookingStatus: [-3, -1, 0, 1, 3],
    );

    teacherInfos = await _client.getTeacherInfos(
      branchName: branchName,
    );

    var _teacherColors = Map<String, Color?>.fromIterable(
      teacherInfos,
      key: (item) => item.teacherID,
      value: (item) => item.color,
    );

    var _teachers = await _client.getTeachers(
      teacherID: teacherID,
      branchName: branchName,
    );

    reservationDataSource = ReservationDataSource();

    timeRegions = [];
    await Future.forEach<Teacher>(_teachers, (element) async {
      timeRegions.add(TimeRegion(
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
      timeRegions.add(TimeRegion(
        startTime: element.controlStart,
        endTime: element.controlEnd,
        color: _teacherColors[element.teacherID]?.withOpacity(0.2) ??
            symbolColor.withOpacity(0.2),
        resourceIds: [_teacherColors.keys.toList().indexOf(element.teacherID)],
      ));
    });

    update();
  }

  Future<void> getReservationForTeacherData() async {
    var teacherID = profile.userID;

    var first = DateTime(displayDate.year, displayDate.month,
        displayDate.day - displayDate.weekday % 7);
    var last =
        first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    teacherInfos = [
      TeacherInfo(teacherID: teacherID, color: symbolColor),
    ];

    reservations = [];
    await Future.forEach<String>(branches, (element) async {
      reservations.addAll(await _client.getReservations(
        branchName: element,
        teacherID: teacherID,
        startDate: first,
        endDate: last,
        bookingStatus: [-3, -1, 0, 1, 3],
      ));
    });

    reservationDataSource = ReservationDataSource();

    timeRegions = [];
    await Future.forEach<Teacher>(teachers, (element) async {
      timeRegions.add(TimeRegion(
        startTime: first.subtract(Duration(days: 7)).add(element.startTime),
        endTime: first.subtract(Duration(days: 7)).add(element.endTime),
        recurrenceRule:
            "FREQ=WEEKLY;INTERVAL=1;BYDAY=${element.workDowToString.substring(0, 2)};COUNT=3",
        color: symbolColor.withOpacity(0.2),
        resourceIds: [0],
      ));
    });

    List<Control> _controls = [];
    await Future.forEach<String>(branches, (element) async {
      _controls.addAll(await _client.getControls(
        branchName: element,
        teacherID: teacherID,
        controlStart: first,
        controlEnd: last,
        status: 0,
      ));
    });
    await Future.forEach<Control>(_controls, (element) async {
      timeRegions.add(TimeRegion(
        startTime: element.controlStart,
        endTime: element.controlEnd,
        color: symbolColor.withOpacity(0.2),
        resourceIds: [0],
      ));
    });

    update();
  }

  Future<void> getUsersData({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
    int? termID,
  }) async {
    users = await _client.getUsers(
      branchName: branchName,
      userID: userID,
      isPaid: isPaid,
      userType: userType,
      status: status,
      termID: termID,
    );
    update();
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
    var today = DateTime.now();

    try {
      regularSchedules = await _client.getRegularSchedulesByAdmin(user.userID);
    } on NetworkException catch (e) {
      // regular schedule not found
      if (e.response?.statusCode == 404) {
        regularSchedules = [
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
      thisMonthReservations = await _client.getReservations(
        branchName: user.branchName,
        startDate: DateTime(today.year, today.month, 1),
        endDate: DateTime(today.year, today.month + 1, 0, 23, 59, 59),
        userID: user.userID,
        bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
      );

      lastMonthReservations = await _client.getReservations(
        branchName: user.branchName,
        startDate: DateTime(today.year, today.month - 1, 1),
        endDate: DateTime(today.year, today.month, 0, 23, 59, 59),
        userID: user.userID,
        bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
      );

      changes = await _client.getChangesWithID(user.userID);

      myLedgers = await _client.getLedgers(
        userID: user.userID,
      );
    } else {
      thisMonthReservations = [];
      lastMonthReservations = [];
      changes = [];
      myLedgers = [];

      if (user.userType == 1) {
        var _teacherInfos = await _client.getTeacherInfos(
          branchName: user.branchName,
        );
        var _teacherIds = _teacherInfos.map((e) => e.teacherID).toList();
        var _index = _teacherIds.indexOf(user.userID);

        var _search = Get.find<CacheController>(tag: "/search/user");
        _search.teacherColor =
            _index == -1 ? null : _teacherInfos[_index].color;
      }
    }

    update();
  }

  Future<void> getControlsData({
    required String branchName,
    String? teacherID,
    DateTime? controlStart,
    DateTime? controlEnd,
    int? status,
  }) async {
    controls = await _client.getControls(
      branchName: branchName,
      teacherID: teacherID,
      controlStart: controlStart,
      controlEnd:
          controlEnd?.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
      status: status,
    );

    update();
  }

  Future<void> getControlsForTeacherData({
    DateTime? controlStart,
    DateTime? controlEnd,
  }) async {
    controls = [];
    await Future.forEach<String>(branches, (element) async {
      controls.addAll(await _client.getControls(
        branchName: element,
        teacherID: profile.userID,
        controlStart: controlStart,
        controlEnd: controlEnd,
      ));
    });
    controls.sort((a, b) => b.controlStart.compareTo(a.controlStart));

    update();
  }
}

class CacheController extends GetxController {
  bool isSearched = false;

  bool hasBeenShown = false;

  Map<int, DateTime?> dateTime = {};
  Map<int, DateTime?> date = {};
  Map<int, TimeOfDay?> time = {};

  Map<int, int?> check = {};

  User? userDetail;
  Color? teacherColor;

  // for dropdown
  String? branchName;
  int? workDow;
  int? termID;
  Duration? duration;
  UserType? userType = UserType.student;
  ControlStatus? controlStatus = ControlStatus.open;
  CancelInClose? cancelInClose = CancelInClose.none;

  var edit1 = TextEditingController();
  var edit2 = TextEditingController();
  var edit3 = TextEditingController();
  var edit4 = TextEditingController();

  void reset() {
    isSearched = false;

    dateTime = {};
    date = {};
    time = {};
    check = {};

    branchName = null;
    workDow = null;
    termID = null;
    duration = null;
    userType = UserType.student;
    controlStatus = ControlStatus.open;
    cancelInClose = CancelInClose.none;

    edit1.clear();
    edit2.clear();
    edit3.clear();
    edit4.clear();
  }

  @override
  void onClose() {
    edit1.dispose();
    edit2.dispose();
    edit3.dispose();
    edit4.dispose();
    super.onClose();
  }
}
