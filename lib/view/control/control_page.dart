import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/control/control_list.dart';
import 'package:solviolin_admin/view/control/control_search.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/single.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  Client client = Get.find<Client>();

  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");
  DateTimeController start =
      Get.put(DateTimeController(), tag: "StartRegister");
  DateTimeController end = Get.put(DateTimeController(), tag: "EndRegister");
  RadioController<StatusType> status =
      Get.put(RadioController<StatusType>(), tag: "Status");
  RadioController<CancelInCloseType> cancelInClose =
      Get.put(RadioController<CancelInCloseType>(), tag: "CancelInClose");

  SearchController search = Get.find<SearchController>(tag: "Control");

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("오픈/클로즈"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: ControlSearch(),
              ),
              myDivider(),
              Expanded(
                child: ControlList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: _showRegister,
        ),
      ),
    );
  }

  Future _showRegister() {
    return showMyDialog(
      context: context,
      title: "오픈/클로즈 등록",
      contents: [
        myTextInput("강사", teacher, "강사명을 입력하세요!"),
        branchDropdown("Register", "지점을 선택하세요!"),
        pickDateTime(context, "시작일", "StartRegister", true),
        pickDateTime(context, "종료일", "EndRegister", true),
        myRadio<StatusType>(
          tag: "Status",
          item: "오픈/클로즈",
          names: ["오픈", "클로즈"],
          values: [StatusType.open, StatusType.close],
          groupValue: StatusType.open,
        ),
        myRadio<CancelInCloseType>(
          tag: "CancelInClose",
          item: "기간 내",
          names: ["유지", "취소", "삭제"],
          values: [
            CancelInCloseType.none,
            CancelInCloseType.cancel,
            CancelInCloseType.delete,
          ],
          groupValue: CancelInCloseType.none,
        ),
      ],
      onPressed: () async {
        try {
          await client.registerControl(
            teacherID: teacher.text,
            branchName: branch.branchName!,
            controlStart: start.dateTime!,
            controlEnd: end.dateTime!,
            status: status.type == StatusType.open ? 0 : 1,
            cancelInClose: cancelInClose.type == CancelInCloseType.none
                ? 0
                : cancelInClose.type == CancelInCloseType.cancel
                    ? 1
                    : 2,
          );

          if (search.isSearched) {
            await getControlsData(
              branchName: search.text1!,
              teacherID: search.text2,
              startDate: search.dateTime1,
              endDate: search.dateTime2,
              status: search.number1,
            );
          }

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

enum StatusType {
  open,
  close,
}

enum CancelInCloseType {
  none,
  cancel,
  delete,
}
