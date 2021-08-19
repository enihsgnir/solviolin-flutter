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
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            child: ListView(
              children: [
                Container(height: 150),
                Column(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menu(String name, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(96, 128, 104, 100),
            borderRadius: BorderRadius.circular(15),
          ),
          width: 165,
          height: 60,
          child: Text(name),
        ),
        onTap: onTap,
        enableFeedback: false,
      ),
    );
  }
}
