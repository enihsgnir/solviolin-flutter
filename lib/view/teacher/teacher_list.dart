import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  Client client = Get.find<Client>();

  SearchController search = Get.find<SearchController>(tag: "Teacher");

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.teachers.length,
          itemBuilder: (context, index) {
            Teacher teacher = controller.teachers[index];

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
                              "강사 스케줄 삭제",
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
                                    await client.deleteTeacher(teacher.id);

                                    await getTeachersData(
                                      teacherID: search.text1,
                                      branchName: search.text2,
                                    );

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
                                child: Text(
                                  "확인",
                                  style: TextStyle(fontSize: 20.r),
                                ),
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
                height: 120.r,
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
                      Text("${teacher.teacherID} / ${teacher.branchName}"),
                      Text("${dowToString(teacher.workDow)}" +
                          " / ${timeToString(teacher.startTime)}" +
                          " : ${timeToString(teacher.endTime)}"),
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
}
