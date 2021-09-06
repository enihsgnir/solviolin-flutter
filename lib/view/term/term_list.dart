import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';

class TermList extends StatefulWidget {
  const TermList({Key? key}) : super(key: key);

  @override
  _TermListState createState() => _TermListState();
}

class _TermListState extends State<TermList> {
  Client client = Get.find<Client>();

  DateTimeController start = Get.put(DateTimeController(), tag: "StartUpdate");
  DateTimeController end = Get.put(DateTimeController(), tag: "EndUpdate");

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.terms.length,
          itemBuilder: (context, index) {
            Term term = controller.terms[index];

            return Slidable(
              actionPane: SlidableScrollActionPane(),
              secondaryActions: [
                mySlideAction(
                  icon: CupertinoIcons.pencil,
                  item: "수정",
                  onTap: () => showMyDialog(
                    context: context,
                    title: "학기 수정",
                    contents: [
                      pickDate(context, "시작일", "StartUpdate", true),
                      pickDate(context, "종료일", "EndUpdate", true),
                    ],
                    onPressed: () async {
                      try {
                        await client.modifyTerm(
                          term.id,
                          termStart: start.date!,
                          termEnd: end.date!,
                        );

                        Get.back();
                      } catch (e) {
                        showError(e.toString());
                      }
                    },
                  ),
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.r),
                decoration: myDecoration,
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white, fontSize: 24.r),
                  child: Column(
                    children: [
                      Text("시작: " +
                          DateFormat("yy/MM/dd").format(term.termStart)),
                      Text(
                          "종료: " + DateFormat("yy/MM/dd").format(term.termEnd)),
                      Text("ID: ${term.id}"),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
