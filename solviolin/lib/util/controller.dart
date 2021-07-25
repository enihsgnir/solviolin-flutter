import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class DataController extends GetxController {
  List<bool> isComplete = [];
  List<bool> isAllComplete = [];
  LinkedHashSet<String> messages = LinkedHashSet();
  late User user;
  late List<RegularSchedule> regularSchedules;
  late List<Teacher> teachers;
  late List<Reservation> myReservations;
  late List<Reservation> teacherReservations;
  late List<Reservation> myValidReservations;
  late List<Reservation> teacherOnlyValidReservations;
  late List<Reservation> myCurrentValidReservations;

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

  void cacheMessage(String data) {
    messages.add(data);
    update();
  }

  void resetMessages() {
    messages = LinkedHashSet();
    update();
  }

  void updateUser(dynamic data) {
    if (data is User) {
      user = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateRegularSchedules(dynamic data) {
    if (data is List<RegularSchedule>) {
      regularSchedules = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateTeachers(dynamic data) {
    if (data is List<Teacher>) {
      teachers = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateMyReservations(dynamic data) {
    if (data is List<Reservation>) {
      myReservations = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateTeacherReservations(dynamic data) {
    if (data is List<Reservation>) {
      teacherReservations = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateMyValidReservations(dynamic data) {
    if (data is List<Reservation>) {
      myValidReservations = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }

  void updateTeacherOnlyValidReservations(dynamic data) {
    if (data is List<Reservation>) {
      teacherOnlyValidReservations = data;
    } else if (data == null) {
      // do nothing
    }
    update();
  }
}
