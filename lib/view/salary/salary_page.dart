import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/view/salary/salaray_list.dart';
import 'package:solviolin_admin/view/salary/salary_search.dart';
import 'package:solviolin_admin/widget/single.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("급여 계산"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: SalarySearch(),
              ),
              myDivider(),
              Expanded(
                child: SalaryList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
