import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/term/term_list.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TermPage extends StatefulWidget {
  const TermPage({Key? key}) : super(key: key);

  @override
  _TermPageState createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  Client client = Get.find<Client>();

  DataController _controller = Get.find<DataController>();

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
          padding: EdgeInsets.all(32.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                child: Icon(Icons.menu, size: 36.r),
                heroTag: null,
                onPressed: _showMenu,
              ),
              FloatingActionButton(
                child: Icon(Icons.add, size: 36.r),
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
              fontSize: 28.r,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                child: pickDate(context, "시작일", "Start", true),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                child: pickDate(context, "종료일", "End", true),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 12.r,
                  horizontal: 16.r,
                ),
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
                  await client.registerTerm(
                    termStart: start.date!,
                    termEnd: end.date!,
                  );

                  _controller.updateTerms(await client.getTerms(10));

                  Get.back();
                } catch (e) {
                  showError(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: symbolColor,
                padding: EdgeInsets.symmetric(
                  vertical: 12.r,
                  horizontal: 16.r,
                ),
              ),
              child: Text("등록", style: TextStyle(fontSize: 20.r)),
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
              child: Text("정규 연장 (지점)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: _showExtendOfUser,
              child: Text("정규 연장 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
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
              fontSize: 28.r,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
            child: branchDropdown(null, "지점을 선택하세요!"),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 12.r,
                  horizontal: 16.r,
                ),
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
                  await client.extendAllCoursesOfBranch(branch.branchName!);

                  Get.back();
                } catch (e) {
                  showError(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: symbolColor,
                padding: EdgeInsets.symmetric(
                  vertical: 12.r,
                  horizontal: 16.r,
                ),
              ),
              child: Text("등록", style: TextStyle(fontSize: 20.r)),
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
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              "정규 연장 (수강생)",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.r,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
              child: input("이름", user, "이름을 입력하세요!"),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
                  ),
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
                    await client.extendAllCoursesOfUser(user.text);

                    Get.back();
                  } catch (e) {
                    showError(context, e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: symbolColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
                  ),
                ),
                child: Text("등록", style: TextStyle(fontSize: 20.r)),
              ),
            ],
          ),
        );
      },
    );
  }
}
