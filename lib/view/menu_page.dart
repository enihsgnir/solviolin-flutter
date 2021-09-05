import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Client client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  TextEditingController branch = TextEditingController();

  @override
  void dispose() {
    branch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchController(), tag: "Main");
    Get.put(SearchController(), tag: "User");
    Get.put(SearchController(), tag: "Control");
    Get.put(SearchController(), tag: "Teacher");
    Get.put(SearchController(), tag: "Branch");

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
              menu("로그아웃", _showLogout, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu(String name, void Function() onPressed,
      [bool isDestructive = false]) {
    return ElevatedButton(
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
    );
  }

  Future _showBranchRegister() {
    return showMyDialog(
      context: context,
      title: "지점 등록",
      contents: [
        textInput("지점명", branch, "지점명을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          await client.registerBranch(branch.text);

          _controller.updateBranches(await client.getBranches());
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
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
