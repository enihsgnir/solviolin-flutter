import 'package:flutter/material.dart';
import 'package:solviolin_admin/view/check_in/check_in_history_list.dart';
import 'package:solviolin_admin/widget/single.dart';

class CheckInHistoryPage extends StatefulWidget {
  const CheckInHistoryPage({Key? key}) : super(key: key);

  @override
  _CheckInHistoryPageState createState() => _CheckInHistoryPageState();
}

class _CheckInHistoryPageState extends State<CheckInHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("체크인 이력"),
      body: SafeArea(
        child: CheckInHistoryList(),
      ),
    );
  }
}
