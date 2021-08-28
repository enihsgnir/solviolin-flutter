import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/control.dart';
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

            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 1 / 5,
              secondaryActions: [
                SlideAction(
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.delete, size: 48.r),
                          Text(
                            "삭제",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.r,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black26,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "오픈/클로즈 삭제",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.r,
                              ),
                            ),
                            content: Text(
                              "정말 삭제하시겠습니까?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.r,
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(
                                      16.r, 12.r, 16.r, 12.r),
                                ),
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.r),
                                ),
                              ),
                              ElevatedButton(
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
                                    showError(context, e.toString());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: symbolColor,
                                  padding: EdgeInsets.fromLTRB(
                                      16.r, 12.r, 16.r, 12.r),
                                ),
                                child: Text("확인",
                                    style: TextStyle(fontSize: 20.r)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.r),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white, fontSize: 28.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${control.teacherID} / ${control.branchName}" +
                          " / ${_statusToString(control.status)}"),
                      Text("시작: " +
                          DateFormat("yy/MM/dd HH:mm")
                              .format(control.controlStart)),
                      Text("종료: " +
                          DateFormat("yy/MM/dd HH:mm")
                              .format(control.controlEnd)),
                    ],
                  ),
                ),
              ),
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
