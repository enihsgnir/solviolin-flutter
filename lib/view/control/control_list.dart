import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';

class ControlList extends StatefulWidget {
  const ControlList({Key? key}) : super(key: key);

  @override
  _ControlListState createState() => _ControlListState();
}

class _ControlListState extends State<ControlList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.controls.length,
          itemBuilder: (context, index) {
            Control control = controller.controls[index];

            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 1 / 5,
              secondaryActions: [
                SlideAction(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.delete_left, size: 48),
                        Text(
                          "취소",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    onTap: () async {},
                  ),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  children: [
                    Text("${control.teacherID} / ${control.branchName}" +
                        " / ${controlStatusToString(control.status)}"),
                    Text("시작: " +
                        DateFormat("yy/MM/dd HH:mm")
                            .format(control.controlStart)),
                    Text("종료: " +
                        DateFormat("yy/MM/dd HH:mm")
                            .format(control.controlEnd)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
