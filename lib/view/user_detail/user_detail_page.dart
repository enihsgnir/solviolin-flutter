import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user_detail/changed_reservation.dart';
import 'package:solviolin_admin/view/user_detail/history_reserved.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/picker.dart';
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

  SearchController search = Get.find<SearchController>(tag: "User");
  DetailController detail = Get.find<DetailController>();

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
      appBar: myAppBar("유저 상세"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 225.r,
                      child: PageView.builder(
                        controller: PageController(),
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: controller.regularSchedules.length,
                        itemBuilder: (context, index) {
                          RegularSchedule regular =
                              controller.regularSchedules[index];

                          return DefaultTextStyle(
                            style: TextStyle(fontSize: 28.r),
                            child: Container(
                              decoration: myDecoration,
                              margin: EdgeInsets.all(8.r),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(
                                        24.r, 12.r, 24.r, 0),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(regular.userID),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: symbolColor,
                                          ),
                                          onPressed: () => showMyDialog(
                                            context: context,
                                            title: "정규 종료",
                                            contents: [
                                              pickDateTime(
                                                  context, "종료일", null, true),
                                            ],
                                            onPressed: () async {
                                              try {
                                                await client
                                                    .updateEndDateAndDeleteLaterCourse(
                                                  regular.id,
                                                  endDate: end.date!,
                                                );
                                                await getUsersData(
                                                  branchName: search.text1,
                                                  userID: search.text2,
                                                  isPaid: search.number1,
                                                  status: search.number2,
                                                );
                                                await getUserDetailData(
                                                    detail.user!);

                                                Get.back();
                                              } catch (e) {
                                                showError(e.toString());
                                              }
                                            },
                                          ),
                                          child: Text(
                                            "정규 종료",
                                            style: TextStyle(fontSize: 20.r),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    regular.teacherID +
                                        " / ${regular.branchName}",
                                  ),
                                  Text(
                                    "${dowToString(regular.dow)}" +
                                        " / ${timeToString(regular.startTime)}" +
                                        " ~ ${timeToString(regular.endTime)}",
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
                          margin: EdgeInsets.only(bottom: 16.r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              controller.regularSchedules.length,
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
                  margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                  color: Colors.grey,
                  height: 0.5,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey,
                                width: 0.5.r,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _showExpend,
                            child: Text(
                              "원비납부",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey,
                                width: 0.5.r,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _showUpdate,
                            child: Text(
                              "정보수정",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.r),
                  color: Colors.grey,
                  height: 0.5.r,
                ),
                TabBar(
                  controller: tabController,
                  enableFeedback: false,
                  tabs: [
                    Tab(
                      child: Text("지난 달", style: TextStyle(fontSize: 28.r)),
                    ),
                    Tab(
                      child: Text("이번 달", style: TextStyle(fontSize: 28.r)),
                    ),
                    Tab(
                      child: Text("변경 내역", style: TextStyle(fontSize: 28.r)),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(8.r),
                  color: Colors.grey,
                  height: 0.5.r,
                ),
                Container(
                  height: 700.r,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child:
                            HistoryReserved(controller.lastMonthReservations),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child:
                            HistoryReserved(controller.thisMonthReservations),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
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
        color: isActive ? symbolColor : Colors.grey,
        shape: BoxShape.circle,
      ),
      width: isActive ? 12.r : 8.r,
      height: isActive ? 12.r : 8.r,
      margin: EdgeInsets.symmetric(horizontal: 8.r),
      duration: const Duration(milliseconds: 150),
    );
  }

  Future _showExpend() {
    return showMyDialog(
      context: context,
      title: "원비납부",
      contents: [
        textInput("금액", amount, "금액을 입력하세요!"),
        branchDropdown("Expend", "지점을 선택하세요!"),
        termDropdown("지점을 선택하세요!"),
      ],
      onPressed: () async {
        try {
          await client.registerLedger(
            userID: _controller.regularSchedules[0].userID,
            amount: int.parse(amount.text),
            termID: term.termID!,
            branchName: expend.branchName!,
          );
          await getUsersData(
            branchName: search.text1,
            userID: search.text2,
            isPaid: search.number1,
            status: search.number2,
          );
          await getUserDetailData(detail.user!);

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      isScrolling: true,
    );
  }

  Future _showUpdate() {
    return showMyDialog(
      context: context,
      title: "정보수정",
      contents: [
        branchDropdown("Update"),
        textInput("전화번호", phone),
        check(
          tag: "Update",
          item: "등록 여부",
          trueName: "등록",
          falseName: "미등록",
        ),
        textInput("크레딧", credit),
        textInput("이름", name),
      ],
      onPressed: () {},
      isScrolling: true,
    );
  }
}
