import 'package:get/get.dart';
import 'package:solviolin/model/change.dart';
import 'package:solviolin/model/profile.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/term.dart';

class DataController extends GetxController {
  //TODO: remove some unnecessary functions
  late final double ratio;

  late Profile profile;

  late List<RegularSchedule> regularSchedules;
  late List<DateTime> availabaleSpots;
  late List<Reservation> myValidReservations;
  late List<Term> currentTerm;

  DateTime selectedDay = DateTime.now();
  late DateTime focusedDay;

  late List<Reservation> thisMonthReservations;
  late List<Reservation> lastMonthReservations;
  late List<Change> changes;

  void updateRatio(double data) {
    ratio = data;
    update();
  }

  void updateProfile(Profile data) {
    profile = data;
    update();
  }

  void updateRegularSchedules(List<RegularSchedule> data) {
    regularSchedules = data;
    update();
  }

  void updateAvailableSpots(List<DateTime> data) {
    availabaleSpots = data;
    update();
  }

  void updateMyValidReservations(List<Reservation> data) {
    myValidReservations = data;
    update();
  }

  void updateCurrentTerm(List<Term> data) {
    currentTerm = data;
    update();
  }

  void updateDays(DateTime selectedData, DateTime focusedData) {
    selectedDay = selectedData;
    focusedDay = focusedData;
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
}
