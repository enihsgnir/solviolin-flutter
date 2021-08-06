import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/change.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';

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
        List<Change> changes = controller.changes;

        return ListView.builder(
          itemCount: changes.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.r),
              ),
              height: 120.h,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${changes[index].from.teacherID} / ${changes[index].from.branchName}",
                    ),
                    Text(
                      "변경 전: ${dateTimeToString(changes[index].from.startDate)}",
                    ),
                    Text(
                      changes[index].to == null
                          ? "변경 사항이 없습니다."
                          : "변경 후: ${dateTimeToString(changes[index].to!.startDate)}",
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
