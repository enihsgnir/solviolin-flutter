import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Client client = Get.find<Client>();
  TextEditingController branch = TextEditingController();

  @override
  void dispose() {
    branch.dispose();
    super.dispose();
  }

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
                    menu("메인", () => Get.toNamed("/main")),
                    menu("유저", () => Get.toNamed("/user")),
                    menu("오픈/클로즈", () => Get.toNamed("/control")),
                    menu("학기", () => Get.toNamed("/term")),
                    menu("강사", () => Get.toNamed("/teacher")),
                    menu("지점 등록", () => _showBranchRegister()),
                    menu("매출", () => Get.toNamed("/ledger")),
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

  Future _showBranchRegister() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "지점 등록",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: input("지점", branch, "지점명을 입력하세요!"),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: branch.text == ""
                  ? null
                  : () async {
                      try {
                        await client.registerBranch(branch.text);
                      } catch (e) {
                        showErrorMessage(context, e.toString());
                      }
                    },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "등록",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
