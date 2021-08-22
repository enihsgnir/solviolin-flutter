import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/view/canceled/canceled_list.dart';
import 'package:solviolin_admin/view/canceled/canceled_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

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
        appBar: appBar("취소 내역"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: CanceledSearch(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                color: Colors.grey,
                height: 0.5,
              ),
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
