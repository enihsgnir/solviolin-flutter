import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/view/ledger/ledger_list.dart';
import 'package:solviolin_admin/view/ledger/ledger_search.dart';
import 'package:solviolin_admin/widget/single.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({Key? key}) : super(key: key);

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("매출"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: LedgerSearch(),
              ),
              myDivider(),
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
