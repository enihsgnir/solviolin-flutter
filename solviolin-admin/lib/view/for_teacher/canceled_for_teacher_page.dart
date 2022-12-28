import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/single.dart';

class CanceledForTeacherPage extends StatefulWidget {
  const CanceledForTeacherPage({Key? key}) : super(key: key);

  @override
  _CanceledForTeacherPageState createState() => _CanceledForTeacherPageState();
}

class _CanceledForTeacherPageState extends State<CanceledForTeacherPage> {
  var _data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("취소 내역"),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _canceledList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _canceledList() {
    return _data.canceledReservations.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  child: Icon(
                    CupertinoIcons.text_badge_xmark,
                    size: 48.r,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "계정 정보에 해당하는 취소 내역이 없습니다.",
                  style: TextStyle(color: Colors.red, fontSize: 22.r),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _data.canceledReservations.length,
            itemBuilder: (context, index) {
              return myNormalCard(
                children: [
                  Text(_data.canceledReservations[index].toString()),
                ],
              );
            },
          );
  }
}
