import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class CanceledSearch extends StatefulWidget {
  const CanceledSearch({Key? key}) : super(key: key);

  @override
  _CanceledSearchState createState() => _CanceledSearchState();
}

class _CanceledSearchState extends State<CanceledSearch> {
  Client _client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  TextEditingController teacher = TextEditingController();

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      height: 90.r,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24.r, top: 6.r),
            child: input("강사", teacher, "강사명을 입력하세요!"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 36.r),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: symbolColor,
              ),
              onPressed: () async {
                try {
                  _controller.updateCanceledReservations(
                      await _client.getCanceledReservations(teacher.text)
                        ..sort((a, b) => a.startDate.compareTo(b.startDate)));
                } catch (e) {
                  showError(context, e.toString());
                }
              },
              child: Text("검색", style: TextStyle(fontSize: 20.r)),
            ),
          ),
        ],
      ),
    );
  }
}
