import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
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
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(height: 180.r),
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
    );
  }

  Widget menu(String name, void Function() onPressed) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: symbolColor,
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
              fontSize: 28.r,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
            child: input("지점", branch, "지점명을 입력하세요!"),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.r,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await client.registerBranch(branch.text);

                  _controller.updateBranches(await client.getBranches());
                } catch (e) {
                  showError(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: symbolColor,
                padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
              ),
              child: Text("등록", style: TextStyle(fontSize: 20.r)),
            ),
          ],
        );
      },
    );
  }
}
