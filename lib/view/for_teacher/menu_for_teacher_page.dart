import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';

class MenuForTeacherPage extends StatefulWidget {
  const MenuForTeacherPage({Key? key}) : super(key: key);

  @override
  _MenuForTeacherPageState createState() => _MenuForTeacherPageState();
}

class _MenuForTeacherPageState extends State<MenuForTeacherPage> {
  Client client = Get.find<Client>();
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
                try {
                  await getReservationDataForTeacher(
                    displayDate: _controller.displayDate,
                    teacherID: _controller.profile.userID,
                  );
                  Get.toNamed("/main-teacher");
                } catch (e) {
                  showError(e.toString());
                }
              }),
              menu("체크인", () => Get.toNamed("/check-in")),
              menu("로그아웃", _showLogout, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu(String name, void Function() onPressed,
      [bool isDestructive = false]) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isDestructive ? Colors.red : symbolColor,
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

  Future _showLogout() {
    return showMyDialog(
      context: context,
      contents: [
        Text(
          "로그아웃 하시겠습니까?",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: () async {
        try {
          client.logout();
        } catch (e) {} finally {
          Get.offAllNamed("/login");
        }
      },
    );
  }
}
