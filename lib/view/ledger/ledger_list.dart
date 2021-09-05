import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

class LedgerList extends StatefulWidget {
  const LedgerList({Key? key}) : super(key: key);

  @override
  _LedgerListState createState() => _LedgerListState();
}

class _LedgerListState extends State<LedgerList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.ledgers.length,
          itemBuilder: (context, index) {
            Ledger ledger = controller.ledgers[index];

            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              decoration: myDecoration,
              margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 28.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${ledger.userID} / ${ledger.branchName}"),
                    Text(NumberFormat("#,###원").format(ledger.amount)),
                    Text("결제일자: " +
                        DateFormat("yy/MM/dd HH:mm").format(ledger.paidAt)),
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
