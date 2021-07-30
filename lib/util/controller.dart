import 'package:get/get.dart';
import 'package:solviolin/model/control.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class DataController extends GetxController {
  late User user;
  late List<RegularSchedule> regularSchedules;
  late List<Teacher> teachers;
  late List<Reservation> myValidReservations;
  late List<Reservation> teacherOnlyValidReservations;
  late List<Reservation> myThisMonthReservations;
  late List<Reservation> myLastMonthReservations;
  late List<Control> openControls;
  late List<Control> closeControls;

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

  void updateMyValidReservations(List<Reservation> data) {
    myValidReservations = data;
    update();
  }

  void updateTeacherOnlyValidReservations(List<Reservation> data) {
    teacherOnlyValidReservations = data;
    update();
  }

  void updateMyThisMonthReservations(List<Reservation> data) {
    myThisMonthReservations = data;
    update();
  }

  void updateMyLastMonthReservations(List<Reservation> data) {
    myLastMonthReservations = data;
    update();
  }

  void updateOpenControls(List<Control> data) {
    openControls = data;
    update();
  }

  void updateCloseControls(List<Control> data) {
    closeControls = data;
    update();
  }
}
