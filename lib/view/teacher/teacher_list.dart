import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/util/controller.dart';
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.delete, size: 48),
                        Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black26,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "강사 삭제",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            content: Text(
                              "정말 삭제하시겠습니까?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                                onPressed: () async {
                                  try {
                                    await client.deleteTeacher(
                                      teacherID: teacher.teacherID,
                                      branchName: teacher.branchName,
                                    );
                                    Get.back();
                                  } catch (e) {
                                    showErrorMessage(context, e.toString());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromRGBO(96, 128, 104, 100),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                ),
                                child: Text(
                                  "확인",
                                  style: TextStyle(fontSize: 20),
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
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
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
