import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
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
  var _data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menu("메인", () {
                showLoading(() async {
                  try {
                    await getReservationDataForTeacher(
                      displayDate: _data.displayDate,
                      teacherID: _data.profile.userID,
                    );

                    Get.toNamed("/main-teacher");

                    if (_data.reservations.length == 0) {
                      await showMySnackbar(
                        title: "알림",
                        message: "계정 정보에 해당하는 목록이 없습니다.",
                      );
                    }
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("오픈/클로즈", () {
                showLoading(() async {
                  try {
                    await getControlsDataForTeacher(
                      teacherID: _data.profile.userID,
                    );
                    _data.update();

                    Get.toNamed("/control-teacher");

                    if (_data.controls.length == 0) {
                      await showMySnackbar(
                        title: "알림",
                        message: "계정 정보에 해당하는 목록이 없습니다.",
                      );
                    }
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("취소 내역", () {
                showLoading(() async {
                  try {
                    _data.canceledReservations = await _client
                        .getCanceledReservations(_data.profile.userID)
                      ..sort((a, b) => b.startDate.compareTo(a.startDate));
                    _data.update();

                    Get.toNamed("/canceled-teacher");

                    if (_data.canceledReservations.length == 0) {
                      await showMySnackbar(
                        title: "알림",
                        message: "계정 정보에 해당하는 목록이 없습니다.",
                      );
                    }
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("체크인", () => Get.toNamed("/check-in")),
              menu("로그아웃", _showLogout, true),
            ]
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.r),
                      child: e,
                    ))
                .toList(),
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

          await showMySnackbar(
            message: "안전하게 로그아웃 되었습니다.",
          );
        }
      }),
    );
  }
}
