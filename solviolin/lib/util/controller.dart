import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class UserController extends GetxController {
  late User user;
  Future<void> updateData(User data) async {
    user = data;
    update();
  }
}

class MyReservationController extends GetxController {
  late List<Reservation> reservations;
  Future<void> updateData(List<Reservation> data) async {
    reservations = data;
    update();
  }
}

class RegularScheduleController extends GetxController {
  late RegularSchedule regularSchedule;
  Future<void> updateData(RegularSchedule data) async {
    regularSchedule = data;
    update();
  }
}

class TeacherController extends GetxController {
  late Teacher teacher;
  Future<void> updateData(Teacher data) async {
    teacher = data;
    update();
  }
}

class TeacherReservationController extends GetxController {
  late List<Reservation> reservations;
  Future<void> updateData(List<Reservation> data) async {
    reservations = data;
    update();
  }
}

// class CanceledReservationController extends GetxController {
//   late List<Reservation> reservations;
//   Future<void> updateData(List<Reservation> data) async {
//     reservations = data;
//     update();
//   }
// }
