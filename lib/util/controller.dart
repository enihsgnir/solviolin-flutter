import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class DataController extends GetxController {
  late User user;
  late List<RegularSchedule> regularSchedules;
  late List<Teacher> teachers;
  late List<DateTime> availabaleTimes;
  late List<Reservation> myValidReservations;
  late DateTime selectedDay;
  late DateTime focusedDay;
  late List<Reservation> thisMonthReservations;
  late List<Reservation> lastMonthReservations;

  void updateUser(User data) {
    user = data;
    update();
  }

  void updateRegularSchedules(List<RegularSchedule> data) {
    regularSchedules = data;
    update();
  }

  void updateTeachers(List<Teacher> data) {
    teachers = data;
    update();
  }

  void updateAvailableTimes(List<DateTime> data) {
    availabaleTimes = data;
    update();
  }

  void updateMyValidReservations(List<Reservation> data) {
    myValidReservations = data;
    update();
  }

  void updateSelectedDay(DateTime data) {
    selectedDay = data;
    update();
  }

  void updateFocusedDay(DateTime data) {
    focusedDay = data;
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
}
