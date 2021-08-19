import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/term/term_list.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TermPage extends StatefulWidget {
  const TermPage({Key? key}) : super(key: key);

  @override
  _TermPageState createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  Client client = Get.find<Client>();
  DateTimeController start = Get.put(DateTimeController(), tag: "Start");
  DateTimeController end = Get.put(DateTimeController(), tag: "End");
  BranchController branch = Get.put(BranchController());
  TextEditingController user = TextEditingController();

  @override
  void dispose() {
    user.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("학기"),
        body: SafeArea(
          child: TermList(),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                child: Icon(Icons.menu),
                heroTag: null,
                onPressed: _showMenu,
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                heroTag: null,
                onPressed: _showRegister,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future _showRegister() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "학기 등록",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: pickDate(context, "시작일", "Start"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: pickDate(context, "종료일", "End"),
              ),
            ],
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
              onPressed: start.date == null || end.date == null
                  ? () {
                      showErrorMessage(context, "필수 입력값을 확인하세요!");
                    }
                  : () async {
                      try {
                        await client.registerTerm(
                          termStart: start.date!,
                          termEnd: end.date!,
                        );
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

  Future _showMenu() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: _showExtendOfBranch,
              child: Text("정규 연장 (지점)", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: _showExtendOfUser,
              child: Text("정규 연장 (수강생)", style: TextStyle(fontSize: 24)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }

  Future _showExtendOfBranch() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "정규 연장 (지점)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: branchDropdown(null, "지점을 선택하세요!"),
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
              onPressed: branch.branchName == null
                  ? () {
                      showErrorMessage(context, "필수 입력값을 확인하세요!");
                    }
                  : () async {
                      try {
                        await client
                            .extendAllCoursesOfBranch(branch.branchName!);
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

  Future _showExtendOfUser() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "정규 연장 (수강생)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: input("이름", user, "이름을 입력하세요!", true),
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
              onPressed: user.text == ""
                  ? () {
                      showErrorMessage(context, "필수 입력값을 확인하세요!");
                    }
                  : () async {
                      try {
                        await client.extendAllCoursesOfUser(user.text);
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
