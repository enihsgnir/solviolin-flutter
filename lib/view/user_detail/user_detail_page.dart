import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user_detail/history_reserved.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/single.dart';
import 'package:solviolin_admin/widget/swipeable_list.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search");
  var delete = Get.put(CacheController(), tag: "/delete");
  var expend = Get.put(CacheController(), tag: "/expend");
  var update = Get.put(CacheController(), tag: "/update");

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("유저 상세"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return Column(
              children: [
                swipeableList(
                  itemCount: controller.regularSchedules.length,
                  itemBuilder: (context, index) {
                    var regular = controller.regularSchedules[index];

                    return mySwipeableCard(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.r),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(regular.userID),
                              myActionButton(
                                context: context,
                                onPressed: () {
                                  delete.reset();

                                  showMyDialog(
                                    context: context,
                                    title: "정규 종료",
                                    contents: [
                                      pickDateTime(
                                        context: context,
                                        item: "종료일",
                                        tag: "/delete",
                                        isMandatory: true,
                                      ),
                                    ],
                                    onPressed: () => showLoading(() async {
                                      try {
                                        await _client
                                            .updateEndDateAndDeleteLaterCourse(
                                          regular.id,
                                          endDate: delete.date[0]!,
                                        );
                                        await getUsersData(
                                          branchName: search.branchName,
                                          userID: textEdit(search.edit1),
                                          isPaid: search.check[0],
                                          userType: UserType.values
                                              .indexOf(search.type[UserType]),
                                          status: search.check[1],
                                        );
                                        await getUserDetailData(
                                            search.userDetail!);

                                        Get.back();
                                      } catch (e) {
                                        showError(e.toString());
                                      }
                                    }),
                                  );
                                },
                                action: "정규종료",
                              ),
                            ],
                          ),
                        ),
                        Text(regular.teacherID + " / ${regular.branchName}"),
                        Text("${dowToString(regular.dow)}" +
                            " / ${timeToString(regular.startTime)}" +
                            " ~ ${timeToString(regular.endTime)}"),
                      ],
                    );
                  },
                ),
                myDivider(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey, width: 0.5.r),
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
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey, width: 0.5.r),
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
                myDivider(),
                TabBar(
                  controller: tabController,
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
                myDivider(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      HistoryReserved(controller.lastMonthReservations),
                      HistoryReserved(controller.thisMonthReservations),
                      _changedList(),
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

  Widget _changedList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.changes.length,
          itemBuilder: (context, index) {
            var change = controller.changes[index];

            return myNormalCard(
              children: [
                Text("${change.teacherID} / ${change.branchName}"),
                Text("변경 전: " +
                    DateFormat("yy/MM/dd HH:mm").format(change.fromDate)),
                Text(change.toDate == null
                    ? "변경 사항이 없습니다."
                    : "변경 후: " +
                        DateFormat("yy/MM/dd HH:mm").format(change.toDate!)),
              ],
            );
          },
        );
      },
    );
  }

  Future _showExpend() {
    expend.reset();

    return showMyDialog(
      context: context,
      title: "원비납부",
      contents: [
        myTextInput("금액", expend.edit1, "금액을 입력하세요!"),
        branchDropdown("/expend", "지점을 선택하세요!"),
        termDropdown("/expend", "지점을 선택하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerLedger(
            userID: _controller.regularSchedules[0].userID,
            amount: int.parse(textEdit(expend.edit1)!),
            termID: expend.termID!,
            branchName: expend.branchName!,
          );
          await getUsersData(
            branchName: search.branchName,
            userID: textEdit(search.edit1),
            isPaid: search.check[0],
            userType: UserType.values.indexOf(search.type[UserType]),
            status: search.check[1],
          );
          await getUserDetailData(search.userDetail!);

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      isScrolling: true,
    );
  }

  Future _showUpdate() {
    update.reset();

    return showMyDialog(
      context: context,
      title: "정보수정",
      contents: [
        branchDropdown("/update"),
        myTextInput("전화번호", update.edit1),
        myCheckBox(
          tag: "/update",
          item: "등록 여부",
          trueName: "등록",
          falseName: "미등록",
        ),
        myTextInput("크레딧", update.edit2),
        myTextInput("이름", update.edit3),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.updateUserInformation(
            _controller.regularSchedules[0].userID,
            userBranch: update.branchName,
            userPhone: textEdit(update.edit1),
            status: update.check[0],
            userCredit: int.parse(textEdit(update.edit2)!),
            userName: textEdit(update.edit3),
          );

          await getUsersData(
            branchName: search.branchName,
            userID: textEdit(search.edit1),
            isPaid: search.check[0],
            userType: UserType.values.indexOf(search.type[UserType]),
            status: search.check[1],
          );
          await getUserDetailData(search.userDetail!);

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      isScrolling: true,
    );
  }
}
