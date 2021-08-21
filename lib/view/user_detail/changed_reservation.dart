import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';

class ChangedReservation extends StatefulWidget {
  const ChangedReservation({Key? key}) : super(key: key);

  @override
  _ChangedReservationState createState() => _ChangedReservationState();
}

class _ChangedReservationState extends State<ChangedReservation> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.changes.length,
          itemBuilder: (context, index) {
            Change change = controller.changes[index];

            return Container(
              height: 120.r,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 28.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${change.from.teacherID} / ${change.from.branchName}",
                    ),
                    Text(
                      "변경 전: " +
                          DateFormat("yy/MM/dd HH:mm")
                              .format(change.from.startDate),
                    ),
                    Text(
                      change.to == null
                          ? "변경 사항이 없습니다."
                          : "변경 후: " +
                              DateFormat("yy/MM/dd HH:mm")
                                  .format(change.to!.startDate),
                    ),
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
