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

  var control = Get.put(CacheController(), tag: "/search/control");

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
                    await getReservationForTeacherData();

                    Get.toNamed("/main-teacher");

                    if (_data.reservations.isEmpty) {
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
                    if (!control.isSearched) {
                      var today = DateTime.now();
                      control.date[0] =
                          DateTime(today.year, today.month, today.day - 2);
                      control.date[1] =
                          DateTime(today.year, today.month, today.day + 7);
                    }

                    await getControlsForTeacherData(
                      controlStart: control.date[0],
                      controlEnd: control.date[1],
                    );

                    Get.toNamed("/control-teacher");
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("취소 내역", () {
                showLoading(() async {
                  try {
                    _data.canceledReservations = await _client
                        .getCanceledReservations(_data.profile.userID);

                    Get.toNamed("/canceled-teacher");
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("QR 체크인", () => Get.toNamed("/check-in")),
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
    return showMyModal(
      context: context,
      message: "로그아웃 하시겠습니까?",
      children: ["로그아웃"],
      isDestructiveAction: [true],
      onPressed: [
        () => showLoading(() async {
              try {
                try {
                  _data.reset();
                  await _client.logout();
                } catch (_) {
                  rethrow;
                } finally {
                  Get.offAllNamed("/login");
                }
              } catch (e) {
                if (e is NetworkException && e.isTimeout) {
                  showError(e);
                }
              } finally {
                await showMySnackbar(message: "안전하게 로그아웃 되었습니다.");
              }
            }),
      ],
    );
  }
}
