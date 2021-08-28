import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/canceled.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';

class CanceledList extends StatefulWidget {
  const CanceledList({Key? key}) : super(key: key);

  @override
  _CanceledListState createState() => _CanceledListState();
}

class _CanceledListState extends State<CanceledList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.canceledReservations.length,
          itemBuilder: (context, index) {
            Canceled canceled = controller.canceledReservations[index];

            return Container(
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
                    Text(
                        "${canceled.teacherID} / ${canceled.userID} / ${canceled.branchName}"),
                    Text(DateFormat("yy/MM/dd HH:mm")
                            .format(canceled.startDate) +
                        " ~ " +
                        DateFormat("HH:mm").format(canceled.endDate)),
                    Text(canceled.toID.length == 0
                        ? "보강 미예약"
                        : "보강 ID: " + canceled.toID.toString()),
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
