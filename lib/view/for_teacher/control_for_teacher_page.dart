import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/single.dart';

class ControlForTeacherPage extends StatefulWidget {
  const ControlForTeacherPage({Key? key}) : super(key: key);

  @override
  _ControlForTeacherPageState createState() => _ControlForTeacherPageState();
}

class _ControlForTeacherPageState extends State<ControlForTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("오픈/클로즈"),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _controlList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlList() {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.controls.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                textAlign: TextAlign.center,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("오픈/클로즈 목록을 조회할 수 없습니다."),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.controls.length,
                itemBuilder: (context, index) {
                  var control = controller.controls[index];

                  return myNormalCard(
                    children: [
                      Text("${control.teacherID} / ${control.branchName}" +
                          " / ${control.status == 0 ? "오픈" : "클로즈"}"),
                      Text("시작: " +
                          DateFormat("yy/MM/dd HH:mm")
                              .format(control.controlStart)),
                      Text("종료: " +
                          DateFormat("yy/MM/dd HH:mm")
                              .format(control.controlEnd)),
                    ],
                  );
                },
              );
      },
    );
  }
}
