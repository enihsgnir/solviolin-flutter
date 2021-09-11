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

class DataController extends GetxController {
  //TODO: remove some unnecessary functions
  late final double ratio;

  late Profile profile;

  late List<Term> currentTerm;
  List<Term> terms = [];
  late List<String> branches;

  DateTime displayDate = DateTime.now();
  List<TeacherInfo> teacherInfos = [];
  List<Reservation> reservations = [];
  ReservationDataSource? reservationDataSource;

  List<User> users = [];
  late List<RegularSchedule> regularSchedules;
  late List<Reservation> thisMonthReservations;
  late List<Reservation> lastMonthReservations;
  late List<Change> changes;

  List<Control> controls = [];
  List<Teacher> teachers = [];
  List<Canceled> canceledReservations = [];
  List<Salary> salaries = [];
  List<Ledger> ledgers = [];
  late String totalLeger;
  List<CheckIn> checkInHistories = [];

  void updateRatio(double data) {
    ratio = data;
    update();
  }

  void updateProfile(Profile data) {
    profile = data;
    update();
  }

  void updateCurrentTerm(List<Term> data) {
    currentTerm = data;
    update();
  }

  void updateTerms(List<Term> data) {
    terms = data;
    update();
  }

  void updateBranches(List<String> data) {
    branches = data;
    update();
  }

  void updateDisplayDate(DateTime data) {
    displayDate = data;
    update();
  }

  void updateTeacherInfos(List<TeacherInfo> data) {
    teacherInfos = data;
    update();
  }

  void updateReservations(List<Reservation> data) {
    reservations = data;
    update();
  }

  void updateReservationDataSource(ReservationDataSource data) {
    reservationDataSource = data;
    update();
  }

  void updateUsers(List<User> data) {
    users = data;
    update();
  }

  void updateRegularSchedules(List<RegularSchedule> data) {
    regularSchedules = data;
    update();
  }

  void updateThisMonthReservations(List<Reservation> data) {
    thisMonthReservations = data;
    update();
  }

  void updateLastMonthReservations(List<Reservation> data) {
    lastMonthReservations = data;
    update();
  }

  void updateChanges(List<Change> data) {
    changes = data;
    update();
  }

  void updateControls(List<Control> data) {
    controls = data;
    update();
  }

  void updateTeachers(List<Teacher> data) {
    teachers = data;
    update();
  }

  void updateCanceledReservations(List<Canceled> data) {
    canceledReservations = data;
    update();
  }

  void updateSalaries(List<Salary> data) {
    salaries = data;
    update();
  }

  void updateLedgers(List<Ledger> data) {
    ledgers = data;
    update();
  }

  void updateCheckInHistories(List<CheckIn> data) {
    checkInHistories = data;
    update();
  }
}

class CacheController extends GetxController {
  bool isSearched = false;

  Map<int, DateTime?> dateTime = {};
  Map<int, DateTime?> date = {};
  Map<int, TimeOfDay?> time = {};

  Map<int, int?> check = {};

  User? userDetail;

  String? branchName;
  int? workDow;
  int? termID;

  var edit1 = TextEditingController();
  var edit2 = TextEditingController();
  var edit3 = TextEditingController();
  var edit4 = TextEditingController();

  Map<Type, dynamic> type = {};

  void reset() {
    dateTime = {};
    date = {};
    time = {};
    check = {};

    branchName = null;
    workDow = null;
    termID = null;

    edit1.text = "";
    edit2.text = "";
    edit3.text = "";
    edit4.text = "";

    type = {};
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
