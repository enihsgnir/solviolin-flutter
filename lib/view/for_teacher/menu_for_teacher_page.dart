import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/single.dart';

class MenuForTeacherPage extends StatefulWidget {
  const MenuForTeacherPage({Key? key}) : super(key: key);

  @override
  _MenuForTeacherPageState createState() => _MenuForTeacherPageState();
}

class _MenuForTeacherPageState extends State<MenuForTeacherPage> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menu("메인", () {
                showLoading(() async {
                  try {
                    await getReservationDataForTeacher(
                      displayDate: _controller.displayDate,
                      teacherID: _controller.profile.userID,
                    );

                    Get.toNamed("/main-teacher");
                  } catch (e) {
                    showError(e.toString());
                  }
                });
              }),
              menu("체크인", () => Get.toNamed("/check-in")),
              menu("로그아웃", _showLogout, true),
            ],
          ),
        ),
      ),
    );
  }

  Future _showLogout() {
    return showMyDialog(
      contents: [
        Text("로그아웃 하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.logout();
        } catch (_) {
        } finally {
          Get.offAllNamed("/login");
        }
      }),
    );
  }
}
