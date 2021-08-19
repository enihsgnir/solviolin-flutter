import 'package:get/get.dart';
import 'package:solviolin_admin/model/admin_profile.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/data_source.dart';

class DataController extends GetxController {
  late final double ratio;

  late AdminProfile profile;
  late List<String> branches;
  late List<Term> currentTerm;
  List<Reservation> reservations = [];
  ReservationDataSource? reservationDataSource;
  List<String> teacherName = [];
  DateTime selectedDay = DateTime.now();
  List<User> users = [];
  late List<RegularSchedule> regularSchedules;
  late List<Reservation> thisMonthReservations;
  late List<Reservation> lastMonthReservations;
  late List<Change> changes;
  List<Control> controls = [];
  List<Term> terms = [];
  List<Teacher> teachers = [];
  List<Ledger> ledgers = [];
  late String totalLeger;

  void updateRatio(double data) {
    ratio = data;
    update();
  }

  void updateProfile(AdminProfile data) {
    profile = data;
    update();
  }

  void updateBranches(List<String> data) {
    branches = data;
    update();
  }

  void updateCurrentTerm(List<Term> data) {
    currentTerm = data;
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

  void updateTeacherName(List<String> data) {
    teacherName = data;
    update();
  }

  void updateSelectedDay(DateTime data) {
    selectedDay = data;
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

  // updateThisMonthRESVs
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

  void updateTerms(List<Term> data) {
    terms = data;
    update();
  }

  void updateTeachers(List<Teacher> data) {
    teachers = data;
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
  String? text4;
  String? text5;

  DateTime? dateTime1;
  DateTime? dateTime2;

  Duration? time1;
  Duration? time2;

  int? number1;
  int? number2;
}
