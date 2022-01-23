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
                  menu("예약 슬롯", () async {
                    Get.toNamed("/main");

                    if (main.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      main.branchName = _data.profile.branchName;
                      await showMySnackbar(
                        title: "알림",
                        message: "검색값이 없습니다.",
                      );
                    }
                  }),
                  menu("유저 검색", () async {
                    Get.toNamed("/user");

                    if (user.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      user.branchName = _data.profile.branchName;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("학기", () => Get.toNamed("/term")),
                  menu("매출", () async {
                    Get.toNamed("/ledger");

                    if (ledger.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      ledger.branchName = _data.profile.branchName;
                      ledger.termID = _data.currentTerm[0].id;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("강사 스케줄", () async {
                    Get.toNamed("/teacher");

                    if (teacher.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      teacher.branchName = _data.profile.branchName;
                    }
                  }),
                  menu("오픈/클로즈", () async {
                    Get.toNamed("/control");

                    if (control.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      control.branchName = _data.profile.branchName;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("취소 내역", () async {
                    Get.toNamed("/teacher/canceled");

                    if (canceled.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    }
                  }),
                  menu("급여 계산", () async {
                    Get.toNamed("/teacher/salary");

                    if (salary.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
                      salary.branchName = _data.profile.branchName;
                      salary.termID = _data.currentTerm[0].id;
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menu("체크인", () => Get.toNamed("/check-in")),
                  menu("체크인 이력", () async {
                    Get.toNamed("/check-in/history");

                    if (checkIn.isSearched) {
                      await showMySnackbar(
                        title: "알림",
                        message: "검색 기록이 존재합니다. 재검색을 시도하세요.",
                      );
                    } else {
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
        myTextInput("지점명", branch, true),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerBranch(textEdit(branch)!);

          _data.branches = await _client.getBranches();
          _data.update();
          Get.back();

          await showMySnackbar(
            message: "신규 지점 등록에 성공했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
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

          main.isSearched = false;
          user.isSearched = false;
          control.isSearched = false;
          teacher.isSearched = false;
          canceled.isSearched = false;
          salary.isSearched = false;
          ledger.isSearched = false;
          checkIn.isSearched = false;
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
