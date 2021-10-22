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
                            Row(
                              children: []
                                ..addAllIf(search.userDetail!.userType == 0, [
                                  myActionButton(
                                    context: context,
                                    action: "정기삭제",
                                    onPressed: () {
                                      showMyDialog(
                                        title: "정기 삭제",
                                        contents: [
                                          Text("정기 스케줄을 삭제합니다."),
                                          Text("아직 시작되지 않은 정기 스케줄만"),
                                          Text("삭제할 수 있습니다."),
                                        ],
                                        onPressed: () => showLoading(() async {
                                          try {
                                            await _client.deleteRegularSchedule(
                                                regular.id);

                                            await getUsersData(
                                              branchName: search.branchName,
                                              userID: textEdit(search.edit1),
                                              isPaid: search.check[0],
                                              userType: UserType.values.indexOf(
                                                  search.type[UserType]),
                                              status: search.check[1],
                                            );

                                            await getUserDetailData(
                                                search.userDetail!);

                                            Get.back();

                                            await showMySnackbar(
                                              message: "정기 스케줄을 삭제했습니다.",
                                            );
                                          } catch (e) {
                                            showError(e);
                                          }
                                        }),
                                      );
                                    },
                                  ),
                                  myActionButton(
                                    context: context,
                                    action: "정기종료",
                                    onPressed: () {
                                      delete.reset();

                                      showMyDialog(
                                        title: "정기 종료",
                                        contents: [
                                          Text("정기 스케줄의 종료일을 갱신하고"),
                                          Text("종료일 이후의 해당 정기 수업들을 삭제합니다."),
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
                                              userType: UserType.values.indexOf(
                                                  search.type[UserType]),
                                              status: search.check[1],
                                            );

                                            await getUserDetailData(
                                                search.userDetail!);

                                            Get.back();

                                            await showMySnackbar(
                                              message:
                                                  "정기 스케줄을 종료하고 이후 모든 수업을 취소했습니다.",
                                            );
                                          } catch (e) {
                                            showError(e);
                                          }
                                        }),
                                      );
                                    },
                                  ),
                                ])
                                ..addIf(
                                  search.userDetail!.userType == 1,
                                  myActionButton(
                                    context: context,
                                    action: "강사삭제",
                                    onPressed: () {
                                      showMyDialog(
                                        title: "강사 삭제",
                                        contents: [
                                          Text("강사의 유저 데이터를 삭제하시겠습니까?"),
                                        ],
                                        onPressed: () {
                                          showMyDialog(
                                            contents: [
                                              Text("\n\n강사 데이터를 삭제합니다."),
                                              Text("\n*되돌릴 수 없습니다.*\n\n",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                            onPressed: () =>
                                                showLoading(() async {
                                              try {
                                                await _client.terminateTeacher(
                                                    search.userDetail!.userID);

                                                Get.back();
                                                Get.back();

                                                await showMySnackbar(
                                                  message: "강사 데이터를 삭제했습니다.",
                                                );
                                              } catch (e) {
                                                showError(e);
                                              }
                                            }),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ]
                          ..addAllIf(regular.dow != -1, [
                            Text(
                                regular.teacherID + " / ${regular.branchName}"),
                            Text("${dowToString(regular.dow)}" +
                                " / ${timeToString(regular.startTime)}" +
                                " ~ ${timeToString(regular.endTime)}"),
                          ])
                          ..addIf(
                              regular.dow == -1,
                              search.userDetail!.userType == 0
                                  ? Text("\n정기수업 시작 전입니다.")
                                  : search.userDetail!.userType == 1
                                      ? Text("\n강사 상세 페이지입니다.")
                                      : Text("\n관리자 상세 페이지입니다.")));
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
                textAlign: TextAlign.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("변경 내역을 조회할 수 없습니다."),
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
                textAlign: TextAlign.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("납부 내역을 조회할 수 없습니다."),
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
            userID: search.userDetail!.userID,
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
      ]..addAllIf(
          search.userDetail!.userType == 1,
          [
            myTextInput("색상", update.edit4, null),
            Text(
              "\n색상: # + HEX Code\nex) #5F9EA0\ncf) htmlcolorcodes.com",
              style: TextStyle(color: Colors.red, fontSize: 20.r),
            )
          ],
        ),
      onPressed: () => showLoading(() async {
        try {
          var color = textEdit(update.edit4);
          if (color != null) {
            color = color.toUpperCase();
            if (color.substring(0, 1) != "#") {
              color = "#" + color;
            }
            if (color.length != 7) {
              throw FormatException("hex");
            }
            for (int i = 1; i < 7; i++) {
              if (!"0123456789ABCDEF".contains(color.substring(i, i + 1))) {
                throw FormatException("hex");
              }
            }
          }

          await _client.updateUserInformation(
            search.userDetail!.userID,
            userBranch: update.branchName,
            userPhone: textEdit(update.edit1),
            status: update.check[0],
            userCredit: intEdit(update.edit2),
            userName: textEdit(update.edit3),
            color: color,
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
