import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

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
                SlideAction(
                  child: Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.pencil, size: 48),
                          Text(
                            "수정",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black26,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "학기 수정",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 12, 0),
                                    child:
                                        pickDate(context, "시작일", "StartUpdate"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 12, 0),
                                    child:
                                        pickDate(context, "종료일", "EndUpdate"),
                                  ),
                                ],
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 12),
                                  ),
                                  child: Text(
                                    "취소",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed:
                                      start.date == null || end.date == null
                                          ? null
                                          : () async {
                                              try {
                                                await client.modifyTerm(
                                                  term.id,
                                                  termStart: start.date!,
                                                  termEnd: end.date!,
                                                );
                                                Get.back();
                                              } catch (e) {
                                                showErrorMessage(
                                                    context, e.toString());
                                              }
                                            },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromRGBO(96, 128, 104, 100),
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 12),
                                  ),
                                  child: Text(
                                    "확인",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
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
