import 'package:flutter/material.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/view/salary/salaray_list.dart';
import 'package:solviolin_admin/view/salary/salary_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

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
        appBar: appBar("급여 계산"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: SalarySearch(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                color: Colors.grey,
                height: 0.5,
              ),
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
