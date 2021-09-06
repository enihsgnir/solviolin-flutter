import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

class CheckInHistoryList extends StatefulWidget {
  const CheckInHistoryList({Key? key}) : super(key: key);

  @override
  _CheckInHistoryListState createState() => _CheckInHistoryListState();
}

class _CheckInHistoryListState extends State<CheckInHistoryList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.terms.length,
          itemBuilder: (context, index) {
            Term term = controller.terms[index]; //TODO: apply with histories

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.r),
              decoration: myDecoration,
              margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 24.r),
                child: Column(
                  children: [
                    Text("시작: "),
                    Text("종료: "),
                    Text("ID: ${term.id}"),
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
