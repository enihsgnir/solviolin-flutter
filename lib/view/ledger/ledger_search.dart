import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
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
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24.r),
            child: branchDropdown(null, "지점을 선택하세요!"),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24.r, top: 6.r),
                child: input("수강생", user, "이름을 입력하세요!"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      await getTotalLedgerData(
                        branchName: branch.branchName!,
                        termID: term.termID!,
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
                                    fontSize: 28.r,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.totalLeger,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.r,
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.r,
                                        horizontal: 16.r,
                                      ),
                                    ),
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.r,
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
                      showError(context, e.toString());
                    }
                  },
                  child: Text("합계", style: TextStyle(fontSize: 20.r)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24.r, top: 6.r),
                child: termDropdown("학기를 선택하세요!"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      await getLedgersData(
                        branchName: branch.branchName!,
                        termID: term.termID!,
                        userID: user.text,
                      );
                    } catch (e) {
                      showError(context, e.toString());
                    }
                  },
                  child: Text("검색", style: TextStyle(fontSize: 20.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
