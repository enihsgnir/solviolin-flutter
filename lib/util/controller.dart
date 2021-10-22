import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:solviolin_admin/util/data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DataController extends GetxController {
  late final double ratio;

  late Profile profile;

  List<Term> currentTerm = [];
  List<Term> terms = [];
  List<String> branches = [];

  DateTime displayDate =
      DateUtils.dateOnly(DateTime.now()).add(DateTime.now().timeZoneOffset);
  //TODO: set again with timezone

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
  late String totalLeger;
  List<CheckIn> checkInHistories = [];

  void updateDisplayDate(DateTime data) {
    displayDate = data;
    update();
  }

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
    checkInHistories = [];
  }
}

class CacheController extends GetxController {
  var isSearched = false;
  var hasBeenShown = false;

  Map<int, DateTime?> dateTime = {};
  Map<int, DateTime?> date = {};
  Map<int, TimeOfDay?> time = {};

  Map<int, int?> check = {};

  Map<Type, dynamic> type = {};

  User? userDetail;

  String? branchName;
  int? workDow;
  int? termID;
  Duration? duration;

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
    type = {};

    branchName = null;
    workDow = null;
    termID = null;
    duration = null;

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

enum UserType {
  student,
  teacher,
  admin,
}

enum ControlStatus {
  open,
  close,
}

enum CancelInClose {
  none,
  cancel,
  delete,
}
