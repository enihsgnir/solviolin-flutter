import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/view/canceled/canceled_list.dart';
import 'package:solviolin_admin/view/canceled/canceled_search.dart';
import 'package:solviolin_admin/widget/single.dart';

class CancelPage extends StatefulWidget {
  const CancelPage({Key? key}) : super(key: key);

  @override
  _CancelPageState createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("취소 내역"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: CanceledSearch(),
              ),
              myDivider(),
              Expanded(
                child: CanceledList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
