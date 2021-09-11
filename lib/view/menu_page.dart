import 'package:flutter/cupertino.dart';
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
  var _controller = Get.find<DataController>();

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
              menu("메인", () => Get.toNamed("/main")),
              menu("유저", () => Get.toNamed("/user")),
              menu("오픈/클로즈", () => Get.toNamed("/control")),
              menu("학기", () => Get.toNamed("/term")),
              menu("강사 세부", () => Get.toNamed("/teacher")),
              menu("지점 등록", _showBranchRegister),
              menu("매출", () => Get.toNamed("/ledger")),
              menu("체크인", () => Get.toNamed("/check-in")),
              menu("체크인 이력", () => Get.toNamed("/check-in/history")),
              menu("로그아웃", _showLogout, true),
            ], //TODO: touch up number of menus, especially branch-register
          ),
        ),
      ),
    );
  }

  Future _showBranchRegister() {
    branch.text = "";

    return showMyDialog(
      title: "지점 등록",
      contents: [
        myTextInput("지점명", branch, "지점명을 입력하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerBranch(textEdit(branch)!);

          _controller.updateBranches(await _client.getBranches());
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrolling: true,
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
