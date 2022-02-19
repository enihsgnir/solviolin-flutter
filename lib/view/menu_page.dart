import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/single.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var main = Get.put(CacheController(), tag: "/search/main");
  var user = Get.put(CacheController(), tag: "/search/user");
  var control = Get.put(CacheController(), tag: "/search/control");
  var teacher = Get.put(CacheController(), tag: "/search/teacher");
  var canceled = Get.put(CacheController(), tag: "/search/canceled");
  var salary = Get.put(CacheController(), tag: "/search/salary");
  var ledger = Get.put(CacheController(), tag: "/search/ledger");
  var checkIn = Get.put(CacheController(), tag: "/search/check-in");

  var branch = TextEditingController();

  @override
  void dispose() {
    branch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("예약 슬롯", () {
                    showLoading(() async {
                      try {
                        Get.toNamed("/main");

                        if (!main.isSearched) {
                          main.branchName = _data.profile.branchName;

                          await _data.getReservationData(
                            branchName: main.branchName!,
                          );

                          main.isSearched = true;

                          if (_data.reservations.isEmpty) {
                            await showMySnackbar(
                              title: "알림",
                              message: "검색 조건에 해당하는 목록이 없습니다.",
                            );
                          }
                        }
                      } catch (e) {
                        showError(e);
                      }
                    });
                  }),
                  menu("유저 검색", () {
                    user.expandable.expanded = true;
                    Get.toNamed("/user");

                    if (!user.isSearched) {
                      user.branchName = _data.profile.branchName;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("학기", () => Get.toNamed("/term")),
                  menu("매출", () {
                    ledger.expandable.expanded = true;
                    Get.toNamed("/ledger");

                    if (!ledger.isSearched) {
                      ledger.branchName = _data.profile.branchName;
                      ledger.termID = _data.currentTerm[0].id;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("강사 스케줄", () {
                    teacher.expandable.expanded = true;
                    Get.toNamed("/teacher");

                    if (!teacher.isSearched) {
                      teacher.branchName = _data.profile.branchName;
                    }
                  }),
                  menu("오픈/클로즈", () {
                    control.expandable.expanded = true;
                    Get.toNamed("/control");

                    if (!control.isSearched) {
                      control.branchName = _data.profile.branchName;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("취소 내역", () {
                    canceled.expandable.expanded = true;
                    Get.toNamed("/teacher/canceled");
                  }),
                  menu("급여 계산", () {
                    salary.expandable.expanded = true;
                    Get.toNamed("/teacher/salary");

                    if (!salary.isSearched) {
                      salary.branchName = _data.profile.branchName;
                      salary.termID = _data.currentTerm[0].id;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("QR 체크인", () => Get.toNamed("/check-in")),
                  menu("체크인 이력", () {
                    checkIn.expandable.expanded = true;
                    Get.toNamed("/check-in/history");

                    if (!checkIn.isSearched) {
                      checkIn.branchName = _data.profile.branchName;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("지점 등록", _showBranchRegister),
                  menu("로그아웃", _showLogout, true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showBranchRegister() {
    branch.clear();

    return showMyDialog(
      title: "지점 등록",
      contents: [
        myTextInput("지점명", branch, isMandatory: true),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerBranch(textEdit(branch)!);

          _data.branches = await _client.getBranches();
          _data.update();
          Get.back();

          await showMySnackbar(message: "신규 지점 등록에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
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
