import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';

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
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 28.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${ledger.userID} / ${ledger.branchName}"),
                    Text("${ledger.amount} / ${ledger.termID}"),
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
