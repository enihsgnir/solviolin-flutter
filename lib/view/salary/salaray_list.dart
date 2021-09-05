import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/salary.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

class SalaryList extends StatefulWidget {
  const SalaryList({Key? key}) : super(key: key);

  @override
  _SalaryListState createState() => _SalaryListState();
}

class _SalaryListState extends State<SalaryList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.salaries.length,
          itemBuilder: (context, index) {
            Salary salary = controller.salaries[index];

            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              decoration: myDecoration,
              margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 28.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(salary.teacherID),
                    Text("주간근로시간: " +
                        NumberFormat("#,###분").format(salary.dayTime)),
                    Text("야간근로시간: " +
                        NumberFormat("#,###분").format(salary.nightTime)),
                    Text("급여: " + NumberFormat("#,###원").format(salary.income)),
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
