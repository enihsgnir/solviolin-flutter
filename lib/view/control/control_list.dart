import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class ControlList extends StatefulWidget {
  const ControlList({Key? key}) : super(key: key);

  @override
  _ControlListState createState() => _ControlListState();
}

class _ControlListState extends State<ControlList> {
  Client client = Get.find<Client>();

  SearchController search = Get.find<SearchController>(tag: "Control");

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.controls.length,
          itemBuilder: (context, index) {
            Control control = controller.controls[index];

            return myCard(
              slideActions: [
                mySlideAction(
                  icon: CupertinoIcons.delete,
                  item: "삭제",
                  onTap: () => showMyDialog(
                    context: context,
                    title: "오픈/클로즈 삭제",
                    contents: [
                      Text(
                        "정말 삭제하시겠습니까?",
                        style: TextStyle(color: Colors.white, fontSize: 20.r),
                      ),
                    ],
                    onPressed: () async {
                      try {
                        await client.deleteControl(control.id);

                        await getControlsData(
                          branchName: search.text1!,
                          teacherID: search.text2,
                          startDate: search.dateTime1,
                          endDate: search.dateTime2,
                          status: search.number1,
                        );

                        Get.back();
                      } catch (e) {
                        showError(e.toString());
                      }
                    },
                  ),
                ),
              ],
              children: [
                Text("${control.teacherID} / ${control.branchName}" +
                    " / ${_statusToString(control.status)}"),
                Text("시작: " +
                    DateFormat("yy/MM/dd HH:mm").format(control.controlStart)),
                Text("종료: " +
                    DateFormat("yy/MM/dd HH:mm").format(control.controlEnd)),
              ],
            );
          },
        );
      },
    );
  }

  String _statusToString(int status) {
    Map<int, String> _status = {
      0: "Open",
      1: "Close",
    };

    return _status[status]!;
  }
}
