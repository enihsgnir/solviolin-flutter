import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';

class MenuForTeacherPage extends StatefulWidget {
  const MenuForTeacherPage({Key? key}) : super(key: key);

  @override
  _MenuForTeacherPageState createState() => _MenuForTeacherPageState();
}

class _MenuForTeacherPageState extends State<MenuForTeacherPage> {
  DataController _controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menu("메인", () async {
                await getReservationData(
                  focusedDay: DateTime.now(),
                  branchName: _controller.profile.branchName,
                  teacherID: _controller.profile.userID,
                );
                Get.toNamed("/main-teacher");
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu(String name, void Function() onPressed) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: symbolColor,
          textStyle: TextStyle(color: Colors.white, fontSize: 22.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          width: 135.r,
          height: 60.r,
          child: Text(name),
        ),
      ),
    );
  }
}
