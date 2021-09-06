import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/search.dart';

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
    return mySearch(
      padding: EdgeInsets.symmetric(vertical: 16.r),
      contents: [
        Row(
          children: [
            myTextInput("강사", teacher, "강사명을 입력하세요!"),
            myActionButton(
              onPressed: () async {
                try {
                  _controller.updateCanceledReservations(
                      await _client.getCanceledReservations(teacher.text)
                        ..sort((a, b) => a.startDate.compareTo(b.startDate)));
                } catch (e) {
                  showError(e.toString());
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
