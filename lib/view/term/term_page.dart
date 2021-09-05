import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/term/term_list.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/picker.dart';
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
        appBar: myAppBar("학기"),
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
    return showMyDialog(
      context: context,
      title: "학기 등록",
      contents: [
        pickDate(context, "시작일", "Start", true),
        pickDate(context, "종료일", "End", true),
      ],
      onPressed: () async {
        try {
          await client.registerTerm(
            termStart: start.date!,
            termEnd: end.date!,
          );

          _controller.updateTerms(await client.getTerms(10));

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
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
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }

  Future _showExtendOfBranch() {
    return showMyDialog(
      context: context,
      title: "정규 연장 (지점)",
      contents: [
        branchDropdown(null, "지점을 선택하세요!"),
      ],
      onPressed: () async {
        try {
          await client.extendAllCoursesOfBranch(branch.branchName!);

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
    );
  }

  Future _showExtendOfUser() {
    return showMyDialog(
      context: context,
      title: "정규 연장 (수강생)",
      contents: [
        textInput("이름", user, "이름을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          await client.extendAllCoursesOfUser(user.text);

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }
}
