import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/view/ledger/ledger_list.dart';
import 'package:solviolin_admin/view/ledger/ledger_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({Key? key}) : super(key: key);

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("매출"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: LedgerSearch(),
              ),
              Expanded(
                child: LedgerList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
