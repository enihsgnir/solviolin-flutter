import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/control.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class DataController extends GetxController {
  List<bool> isComplete = [];
  List<bool> isAllComplete = [];
  LinkedHashSet<String> messages = LinkedHashSet();
  late User user;
  List<RegularSchedule> regularSchedules = [];
  List<Teacher> teachers = [];
  List<Reservation> myValidReservations = [];
  List<Reservation> teacherOnlyValidReservations = [];
  List<Reservation> myThisMonthReservations = [];
  List<Reservation> myLastMonthReservations = [];
  List<Control> openControls = [];
  List<Control> closeControls = [];

  Future<bool> checkComplete([bool isRefreshed = false]) async {
    bool result = isRefreshed
        ? isComplete.sublist(0, isComplete.length).contains(false)
        : isComplete.contains(false);
    isComplete = [];
    update();
    return !result;
  }

  Future<bool> checkAllComplete() async {
    bool result = isAllComplete.contains(false);
    isComplete = [];
    isAllComplete = [];
    update();
    return !result;
  }

  Future<void> cacheMessage(String data) async {
    messages.add(data);
    update();
  }

  Future<void> resetMessages() async {
    messages = LinkedHashSet();
    update();
  }

  Future<void> updateUser(dynamic data) async {
    if (data is User) {
      user = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  Future<void> updateRegularSchedules(List<RegularSchedule> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      regularSchedules = data;
    }
    update();
  }

  Future<void> updateTeachers(List<Teacher> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      teachers = data;
    }
    update();
  }

  Future<void> updateMyValidReservations(List<Reservation> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      myValidReservations = data;
    }
    update();
  }

  Future<void> updateTeacherOnlyValidReservations(
      List<Reservation> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      teacherOnlyValidReservations = data;
    }
    update();
  }

  Future<void> updateMyThisMonthReservations(List<Reservation> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      myThisMonthReservations = data;
    }
    update();
  }

  Future<void> updateMyLastMonthReservations(List<Reservation> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      myLastMonthReservations = data;
    }
    update();
  }

  Future<void> updateOpenControls(List<Control> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      openControls = data;
    }
    update();
  }

  Future<void> updateCloseControls(List<Control> data) async {
    if (data.length == 0) {
      // do nothing
    } else {
      closeControls = data;
    }
    update();
  }
}
