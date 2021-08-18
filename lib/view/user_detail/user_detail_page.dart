import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user_detail/changed_reservation.dart';
import 'package:solviolin_admin/view/user_detail/history_reserved.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int currentPage = 0;

  DataController _controller = Get.find<DataController>();

  Client client = Get.find<Client>();
  DateTimeController end = Get.put(DateTimeController());

  TextEditingController amount = TextEditingController();
  BranchController expend = Get.put(BranchController(), tag: "Expend");
  TermController term = Get.put(TermController());

  BranchController update = Get.put(BranchController(), tag: "Update");
  TextEditingController phone = TextEditingController();
  CheckController status = Get.put(CheckController(), tag: "Update");
  TextEditingController credit = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    amount.dispose();
    phone.dispose();
    credit.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar("유저 상세"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            List<RegularSchedule> regulars = controller.regularSchedules;

            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 175,
                      child: PageView.builder(
                        controller: PageController(),
                        physics: ClampingScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: regulars.length,
                        itemBuilder: (context, index) {
                          return DefaultTextStyle(
                            style: TextStyle(fontSize: 28),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 12, 24, 0),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("내 수업"),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color.fromRGBO(
                                                96, 128, 104, 100),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierColor: Colors.black26,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "정규 종료",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12,
                                                                  12,
                                                                  12,
                                                                  0),
                                                          child: pickDateTime(
                                                              context, "종료일"),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  16,
                                                                  12,
                                                                  16,
                                                                  12),
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
                                                            end.dateTime == null
                                                                ? null
                                                                : () async {
                                                                    try {
                                                                      await client
                                                                          .updateEndDateAndDeleteLaterCourse(
                                                                        regulars[index]
                                                                            .id,
                                                                        endDate:
                                                                            end.date!,
                                                                      );
                                                                    } catch (e) {
                                                                      showErrorMessage(
                                                                          context,
                                                                          e.toString());
                                                                    }
                                                                  },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: const Color
                                                                  .fromRGBO(96,
                                                              128, 104, 100),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  16,
                                                                  12,
                                                                  16,
                                                                  12),
                                                        ),
                                                        child: Text(
                                                          "등록",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            "정규 종료",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    regulars[index].teacherID +
                                        " / ${regulars[index].branchName}",
                                  ),
                                  Text(
                                    "${dowToString(regulars[index].dow)}" +
                                        " / ${timeToString(regulars[index].startTime)}" +
                                        " ~ ${timeToString(regulars[index].endTime)}",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              regulars.length,
                              (index) => index == currentPage
                                  ? indicator(isActive: true)
                                  : indicator(isActive: false),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _showExpend,
                            child: Text(
                              "원비납부",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _showUpdate,
                            child: Text(
                              "정보수정",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.grey,
                  height: 0.5,
                ),
                TabBar(
                  controller: tabController,
                  enableFeedback: false,
                  tabs: [
                    Tab(
                      child: Text("지난 달", style: TextStyle(fontSize: 28)),
                    ),
                    Tab(
                      child: Text("이번 달", style: TextStyle(fontSize: 28)),
                    ),
                    Tab(
                      child: Text("변경내역", style: TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.grey,
                  height: 0.5,
                ),
                Container(
                  height: 700,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            HistoryReserved(controller.lastMonthReservations),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            HistoryReserved(controller.thisMonthReservations),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ChangedReservation(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget indicator({required bool isActive}) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: isActive ? const Color.fromRGBO(96, 128, 104, 100) : Colors.grey,
        shape: BoxShape.circle,
      ),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      duration: const Duration(milliseconds: 150),
    );
  }

  Future _showExpend() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "원비납부",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: input("금액", amount, "금액을 입력하세요!"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: branchDropdown("Expend", "지점을 선택하세요!"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: termDropdown("지점을 선택하세요!"),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
              onPressed: amount.text == "" ||
                      expend.branchName == null ||
                      term.termID == null
                  ? null
                  : () async {
                      try {
                        await client.registerLedger(
                          userID: _controller.regularSchedules[0].userID,
                          amount: int.parse(amount.text),
                          termID: term.termID!,
                          branchName: expend.branchName!,
                        );
                        Get.back();
                      } catch (e) {
                        showErrorMessage(context, e.toString());
                      }
                    },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "등록",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _showUpdate() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "정보수정",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: branchDropdown("Update", "지점을 선택하세요!"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: input("전화번호", phone, "번호를 입력하세요!"),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: check(
                  tag: "Update",
                  item: "등록 여부",
                  trueName: "등록",
                  falseName: "미등록",
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: input("크레딧", credit, "크레딧을 입력하세요!"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: input("이름", name, "이름을 입력하세요!"),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
              onPressed: update.branchName == null ||
                      phone.text == "" ||
                      status.result == null ||
                      credit.text == "" ||
                      name.text == ""
                  ? null
                  : () async {
                      try {
                        await client.updateUserInformation(
                          _controller.regularSchedules[0].userID,
                          userBranch: update.branchName,
                          userPhone: phone.text == "" ? null : phone.text,
                          status: status.result,
                          userCredit:
                              credit.text == "" ? null : int.parse(credit.text),
                          userName: name.text == "" ? null : name.text,
                        );
                        Get.back();
                      } catch (e) {
                        showErrorMessage(context, e.toString());
                      }
                    },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "등록",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
