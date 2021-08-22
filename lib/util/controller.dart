import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/canceled.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/profile.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/data_source.dart';

class DataController extends GetxController {
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
  List<Ledger> ledgers = [];
  late String totalLeger;

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

  void updateLedgers(List<Ledger> data) {
    ledgers = data;
    update();
  }

  void updateTotalLedger(String data) {
    totalLeger = data;
    update();
  }
}

class SearchController extends GetxController {
  bool isSearched = false;

  String? text1;
  String? text2;
  String? text3;

  DateTime? dateTime1;
  DateTime? dateTime2;

  // Duration? time1;
  // Duration? time2;

  int? number1;
  int? number2;
}

class DetailController extends GetxController {
  User? user;

  void updateUser(User data) {
    user = data;
    update();
  }
}

class BranchController extends GetxController {
  String? branchName;

  void updateBranchName(String data) {
    branchName = data;
    update();
  }
}

class WorkDowController extends GetxController {
  int? workDow;

  void updateWorkDow(int data) {
    workDow = data;
    update();
  }
}

class TermController extends GetxController {
  int? termID;

  void updateTermID(int data) {
    termID = data;
    update();
  }
}

class CheckController extends GetxController {
  int? result;

  void updateResult(int? data) {
    result = data;
    update();
  }
}

class DateTimeController extends GetxController {
  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;

  void updateDate(DateTime? data) {
    date = data;
    update();
  }

  void updateTime(TimeOfDay? data) {
    time = data;
    update();
  }

  void updateDateTime(DateTime? data) {
    dateTime = data;
    update();
  }
}
