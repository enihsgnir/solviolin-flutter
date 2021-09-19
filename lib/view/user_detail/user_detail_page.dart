import 'package:flutter/cupertino.dart';
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
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/user");
  var delete = Get.put(CacheController(), tag: "/delete");
  var expend = Get.put(CacheController(), tag: "/expend");
  var update = Get.put(CacheController(), tag: "/update");
  var reset = Get.put(CacheController(), tag: "/reset");

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 4, vsync: this);
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
                                    title: "정규 종료",
                                    contents: [
                                      Text("정규 스케줄을 종료하고"),
                                      Text("종료일 이후 모든 수업을 삭제합니다."),
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
                                          endDate: delete.dateTime[0]!,
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

                                        await showMySnackbar(
                                          message:
                                              "정규 스케줄을 삭제하고 이후 모든 수업을 취소했습니다.",
                                        );
                                      } catch (e) {
                                        showError(e);
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
                              fontSize: 26.r,
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
                            right: BorderSide(color: Colors.grey, width: 0.5.r),
                          ),
                        ),
                        child: TextButton(
                          onPressed: _showUpdate,
                          child: Text(
                            "정보수정",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.r,
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
                          onPressed: _showReset,
                          child: Text(
                            "PW초기화",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.r,
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
                      child: Text("지난 달", style: TextStyle(fontSize: 22.r)),
                    ),
                    Tab(
                      child: Text("이번 달", style: TextStyle(fontSize: 22.r)),
                    ),
                    Tab(
                      child: Text("변경내역", style: TextStyle(fontSize: 22.r)),
                    ),
                    Tab(
                      child: Text("납부내역", style: TextStyle(fontSize: 22.r)),
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
                      _paidList(),
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
        return controller.changes.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("변경내역을 조회할 수 없습니다."),
                  ],
                ),
              )
            : ListView.builder(
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
                              DateFormat("yy/MM/dd HH:mm")
                                  .format(change.toDate!)),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget _paidList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.myLedgers.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("납부내역을 조회할 수 없습니다."),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: controller.myLedgers.length,
                itemBuilder: (context, index) {
                  var ledger = controller.myLedgers[index];

                  var _termIndex = controller.terms
                      .indexWhere((element) => ledger.termID == element.id);
                  var _termString = _termIndex < 0
                      ? DateFormat("yy/MM/dd")
                              .format(controller.terms.last.termStart) +
                          " 이전"
                      : DateFormat("yy/MM/dd")
                              .format(controller.terms[_termIndex].termStart) +
                          " ~ " +
                          DateFormat("yy/MM/dd")
                              .format(controller.terms[_termIndex].termEnd);

                  return mySlidableCard(
                    slideActions: [
                      mySlideAction(
                        context: context,
                        icon: CupertinoIcons.delete,
                        item: "삭제",
                        onTap: () => showMyDialog(
                          title: "매출 내역 삭제",
                          contents: [
                            Text("정말 삭제하시겠습니까?"),
                          ],
                          onPressed: () => showLoading(() async {
                            try {
                              await _client.deleteLedger(ledger.id);

                              await getUsersData(
                                branchName: search.branchName,
                                userID: textEdit(search.edit1),
                                isPaid: search.check[0],
                                userType: UserType.values
                                    .indexOf(search.type[UserType]),
                                status: search.check[1],
                              );
                              await getUserDetailData(search.userDetail!);

                              Get.back();

                              await showMySnackbar(
                                message: "매출 내역 삭제에 성공했습니다.",
                              );
                            } catch (e) {
                              showError(e);
                            }
                          }),
                        ),
                      ),
                    ],
                    children: [
                      Text("${ledger.userID} / ${ledger.branchName} / " +
                          NumberFormat("#,###원").format(ledger.amount)),
                      Text("학기: " + _termString),
                      Text("결제일자: " +
                          DateFormat("yy/MM/dd HH:mm").format(ledger.paidAt)),
                    ],
                  );
                },
              );
      },
    );
  }

  Future _showExpend() {
    expend.reset();
    expend.branchName = search.userDetail!.branchName;

    return showMyDialog(
      title: "원비납부",
      contents: [
        myTextInput("금액", expend.edit1, "금액을 입력하세요!", TextInputType.number),
        branchDropdown("/expend", "지점을 선택하세요!"),
        termDropdown("/expend", "지점을 선택하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerLedger(
            userID: _data.regularSchedules[0].userID,
            amount: intEdit(expend.edit1)!,
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

          await showMySnackbar(
            message: "원비 납부 내역을 생성했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }

  Future _showUpdate() {
    update.reset();

    return showMyDialog(
      title: "정보수정",
      contents: [
        myTextInput("이름", update.edit3),
        myTextInput("전화번호", update.edit1, null, TextInputType.number),
        myTextInput("크레딧", update.edit2, null, TextInputType.number),
        branchDropdown("/update"),
        myCheckBox(
          tag: "/update",
          item: "등록 여부",
          trueName: "등록",
          falseName: "미등록",
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.updateUserInformation(
            _data.regularSchedules[0].userID,
            userBranch: update.branchName,
            userPhone: textEdit(update.edit1),
            status: update.check[0],
            userCredit: intEdit(update.edit2),
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

          await showMySnackbar(
            message: "유저 정보 수정에 성공했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }

  Future _showReset() {
    reset.reset();

    return showMyDialog(
      title: "비밀번호 초기화",
      contents: [
        Text("${search.userDetail!.userID} 계정의 비밀번호를 새로 설정합니다."),
        myTextInput("비밀번호", reset.edit1, "새로운 비밀번호를 입력하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.resetPassword(
            userID: search.userDetail!.userID,
            userPassword: textEdit(reset.edit1)!,
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

          await showMySnackbar(
            message: "비밀번호 초기화에 성공했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }
}
