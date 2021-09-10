import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/item_list.dart';

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
            var change = controller.changes[index];

            return myNormalCard(
              children: [
                Text(
                  "${change.teacherID} / ${change.branchName}",
                ),
                Text(
                  "변경 전: " +
                      DateFormat("yy/MM/dd HH:mm").format(change.fromDate),
                ),
                Text(
                  change.toDate == null
                      ? "변경 사항이 없습니다."
                      : "변경 후: " +
                          DateFormat("yy/MM/dd HH:mm").format(change.toDate!),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
