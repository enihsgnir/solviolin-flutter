import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("매출"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
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
