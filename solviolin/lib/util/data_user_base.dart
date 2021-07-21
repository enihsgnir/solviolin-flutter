import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';

Future<void> getUserBaseData() async {
  Client client = Get.put(Client());
  UserController _userController = Get.put(UserController());
  MyReservationController _myReservationController =
      Get.put(MyReservationController());
  RegularScheduleController _regularScheduleController =
      Get.put(RegularScheduleController());
  TeacherController _teacherController = Get.put(TeacherController());
  TeacherReservationController _teacherReservationController =
      Get.put(TeacherReservationController());

  _myReservationController.updateData(await client
      // .getReservations(_userController.user.branchName));
      .getReservations("잠실", userID: "sleep"));
  _regularScheduleController.updateData(await client.getRegularSchedule());
  _teacherController.updateData(await client.getTeacher(
      teacherID: _regularScheduleController.regularSchedule.teacherID,
      branchName: _userController.user.branchName));
  _teacherReservationController.updateData(await client.getReservations("잠실",
      teacherID: _teacherController.teacher.teacherID));
}
