import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/single.dart';

class CanceledForTeacherPage extends StatefulWidget {
  const CanceledForTeacherPage({Key? key}) : super(key: key);

  @override
  _CanceledForTeacherPageState createState() => _CanceledForTeacherPageState();
}

class _CanceledForTeacherPageState extends State<CanceledForTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("취소 내역"),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _canceledList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _canceledList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.canceledReservations.length,
          itemBuilder: (context, index) {
            var canceled = controller.canceledReservations[index];

            return myNormalCard(
              children: [
                Text(
                    "${canceled.teacherID} / ${canceled.userID} / ${canceled.branchName}"),
                Text(DateFormat("yy/MM/dd HH:mm").format(canceled.startDate) +
                    " ~ " +
                    DateFormat("HH:mm").format(canceled.endDate)),
                Text(canceled.toID.length == 0
                    ? "보강 미예약"
                    : "보강 ID: " + canceled.toID.toString()),
              ],
            );
          },
        );
      },
    );
  }
}
