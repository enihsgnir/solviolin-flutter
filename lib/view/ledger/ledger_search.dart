import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class LedgerSearch extends StatefulWidget {
  const LedgerSearch({Key? key}) : super(key: key);

  @override
  _LedgerSearchState createState() => _LedgerSearchState();
}

class _LedgerSearchState extends State<LedgerSearch> {
  BranchController branch = Get.put(BranchController());
  TextEditingController user = TextEditingController();
  TermController term = Get.put(TermController());

  @override
  void dispose() {
    user.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24),
            child: branchDropdown(),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24, top: 12),
                child: input("수강생", user),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                  ),
                  onPressed: branch.branchName == null || term.termID == null
                      ? () {
                          showErrorMessage(context, "필수 입력값을 확인하세요!");
                        }
                      : () async {
                          try {
                            await getTotalLedgerData(
                              branchName: "잠실",
                              termID: 1,
                            );
                            showDialog(
                              context: context,
                              barrierColor: Colors.black26,
                              builder: (context) {
                                return GetBuilder<DataController>(
                                  builder: (controller) {
                                    return AlertDialog(
                                      title: Text(
                                        "총 매출",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${controller.totalLeger}원",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
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
                                            "확인",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            showErrorMessage(context, e.toString());
                          }
                        },
                  child: Text(
                    "TOTAL",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: termDropdown(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                  ),
                  onPressed: branch.branchName == null ||
                          term.termID == null ||
                          user.text == ""
                      ? () {
                          showErrorMessage(context, "필수 입력값을 확인하세요!");
                        }
                      : () async {
                          try {
                            await getLedgersData(
                              branchName: branch.branchName!,
                              termID: term.termID!,
                              userID: user.text,
                            );
                          } catch (e) {
                            showErrorMessage(context, e.toString());
                          }
                        },
                  child: Text(
                    "검색",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
