import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: myAppBar("유저 상세"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return Column(
              children: [
                SwipeableList(
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
                              Text(
                                regular.userID +
                                    (search.userDetail!.userType == 1
                                        ? " / " +
                                            (formatColor(search.teacherColor) ??
                                                "NoColor")
                                        : ""),
                              ),
                              Row(
                                children: []
                                  ..addAllIf(
                                    search.userDetail!.userType == 0,
                                    [
                                      myActionButton(
                                        context: context,
                                        action: "정기삭제",
                                        onPressed: () =>
                                            _showDeleteRegular(regular),
                                      ),
                                      myActionButton(
                                        context: context,
                                        action: "정기종료",
                                        onPressed: () =>
                                            _showTerminateRegular(regular),
                                      ),
                                    ],
                                  )
                                  ..addIf(
                                    search.userDetail!.userType == 1,
                                    myActionButton(
                                      context: context,
                                      action: "강사삭제",
                                      onPressed: _showDeleteTeacher,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ]..add(regular.dow != -1
                          ? Text(regular.toString())
                          : Text(() {
                              switch (search.userDetail!.userType) {
                                case 0:
                                  return "\n정기수업 시작 전입니다.";
                                case 1:
                                  return "\n강사 상세 페이지입니다.";
                                default:
                                  return "\n관리자 상세 페이지입니다.";
                              }
                            }())),
                    );
                  },
                ),
                myDivider(),
                Row(
                  children: [
                    _operationButton(
                      onPressed: _showExpend,
                      child: "원비납부",
                      borderRight: true,
                    ),
                    _operationButton(
                      onPressed: _showUpdate,
                      child: "정보수정",
                      borderLeft: true,
                      borderRight: true,
                    ),
                    _operationButton(
                      onPressed: _showReset,
                      child: "PW초기화",
                      borderLeft: true,
                    ),
                  ],
                ),
                myDivider(),
                TabBar(
                  controller: tabController,
                  tabs: ["지난 달", "이번 달", "변경내역", "납부내역"]
                      .map((e) => Tab(
                            child: Text(e, style: TextStyle(fontSize: 22.r)),
                          ))
                      .toList(),
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
        return controller.changes.isEmpty
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
                  return myNormalCard(
                    children: [
                      Text(controller.changes[index].toString()),
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
        return controller.myLedgers.isEmpty
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
                                userType: search.userType?.index,
                                status: search.check[1],
                                termID: search.termID,
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
                      Text(ledger.toString()),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget _operationButton({
    required VoidCallback onPressed,
    required String child,
    bool borderLeft = false,
    bool borderRight = false,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            left: borderLeft
                ? BorderSide(color: Colors.grey, width: 0.5.r)
                : BorderSide.none,
            right: borderRight
                ? BorderSide(color: Colors.grey, width: 0.5.r)
                : BorderSide.none,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            child,
            style: TextStyle(color: Colors.white, fontSize: 26.r),
          ),
        ),
      ),
    );
  }

  Future _showDeleteRegular(RegularSchedule regular) {
    return showMyDialog(
      title: "정기 삭제",
      contents: [
        Text("정기 스케줄을 삭제합니다.\n아직 시작되지 않은 정기 스케줄만\n삭제할 수 있습니다."),
      ],
      onPressed: () {
        showMyDialog(
          title: "경고",
          contents: [
            Text(
              "정말로 정기 스케줄을 삭제하시겠습니까?",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.deleteRegularSchedule(regular.id);

              await getUsersData(
                branchName: search.branchName,
                userID: textEdit(search.edit1),
                isPaid: search.check[0],
                userType: search.userType?.index,
                status: search.check[1],
                termID: search.termID,
              );
              await getUserDetailData(search.userDetail!);
              Get.until(ModalRoute.withName("/user/detail"));
              await showMySnackbar(message: "정기 스케줄을 삭제했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
    );
  }

  Future _showTerminateRegular(RegularSchedule regular) {
    delete.reset();

    return showMyDialog(
      title: "정기 종료",
      contents: [
        Text("정기 스케줄의 종료일을 갱신하고\n종료일 이후의 해당 정기 수업들을\n모두 삭제합니다."),
        pickDateTime(
          context: context,
          item: "종료일",
          tag: "/delete",
          isMandatory: true,
        ),
      ],
      onPressed: () {
        try {
          showMyDialog(
            title: "경고",
            contents: [
              Text("종료일: " + formatDateTime(delete.dateTime[0]!)),
              Text(
                "\n정말로 정기 스케줄을 종료하시겠습니까?",
                style: TextStyle(color: Colors.red),
              ),
            ],
            onPressed: () => showLoading(() async {
              try {
                await _client.updateEndDateAndDeleteLaterCourse(
                  regular.id,
                  endDate: delete.dateTime[0]!,
                );

                await getUsersData(
                  branchName: search.branchName,
                  userID: textEdit(search.edit1),
                  isPaid: search.check[0],
                  userType: search.userType?.index,
                  status: search.check[1],
                  termID: search.termID,
                );
                await getUserDetailData(search.userDetail!);
                Get.until(ModalRoute.withName("/user/detail"));
                await showMySnackbar(
                  message: "정기 스케줄을 종료하고 이후 모든 수업을 취소했습니다.",
                );
              } catch (e) {
                showError(e);
              }
            }),
          );
        } catch (e) {
          showError(e);
        }
      },
    );
  }

  Future _showDeleteTeacher() {
    return showMyDialog(
      title: "강사 삭제",
      contents: [
        Text("강사의 유저 데이터를 삭제하시겠습니까?"),
      ],
      onPressed: () {
        showMyDialog(
          title: "경고",
          contents: [
            Text("강사 데이터를 삭제합니다."),
            Text("\n*되돌릴 수 없습니다.*", style: TextStyle(color: Colors.red)),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.terminateTeacher(search.userDetail!.userID);

              Get.until(ModalRoute.withName("/user/detail"));
              await showMySnackbar(message: "강사 데이터를 삭제했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
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
        myTextInput(
          "금액",
          expend.edit1,
          isMandatory: true,
          keyboardType: TextInputType.number,
        ),
        branchDropdown("/expend", true),
        termDropdown("/expend", true),
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
            userType: search.userType?.index,
            status: search.check[1],
            termID: search.termID,
          );
          await getUserDetailData(search.userDetail!);

          Get.back();

          await showMySnackbar(message: "원비 납부 내역을 생성했습니다.");
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
        myTextInput(
          "전화번호",
          update.edit1,
          keyboardType: TextInputType.phone,
          hintText: "01012345678",
        ),
        myTextInput("크레딧", update.edit2, keyboardType: TextInputType.number),
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
            myTextInput("색상", update.edit4, hintText: "#5F9EA0"),
            Row(
              children: [
                GetBuilder<CacheController>(
                  tag: "/update",
                  builder: (controller) {
                    return Container(
                      alignment: Alignment.center,
                      foregroundDecoration: BoxDecoration(
                        color: parseColor(textEdit(update.edit4)),
                        border: Border.all(color: Colors.grey),
                      ),
                      width: 220.r,
                      height: 35.r,
                      margin: EdgeInsets.all(8.r),
                      child: Text(
                        "Invalid HexCode",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.r,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    update.update();
                  },
                  child: Text("미리보기", style: TextStyle(fontSize: 20.r)),
                ),
              ],
            ),
            Text(
              "색상: # + HEX Code\n참고: htmlcolorcodes.com",
              style: TextStyle(color: Colors.red, fontSize: 20.r),
              textAlign: TextAlign.left,
            )
          ],
        ),
      onPressed: () => showLoading(() async {
        try {
          var phone = textEdit(update.edit1);
          if (phone != null) {
            if (!checkPhone(phone)) {
              throw "올바르지 않은 전화번호 형식입니다.";
            } else {
              phone = trimPhone(phone);
            }
          }

          var color = textEdit(update.edit4)?.toUpperCase();
          if (color != null && !checkHex(color)) {
            throw "올바르지 않은 색상 형식입니다." +
                "\n색상의 HEX Code는 #과 0~9, A~F의 6자리 16진수로 이루어져 있습니다.";
          }

          await _client.updateUserInformation(
            search.userDetail!.userID,
            userBranch: update.branchName,
            userPhone: phone,
            status: update.check[0],
            userCredit: intEdit(update.edit2),
            userName: textEdit(update.edit3),
            color: color,
          );

          await getUsersData(
            branchName: search.branchName,
            userID: textEdit(search.edit1),
            isPaid: search.check[0],
            userType: search.userType?.index,
            status: search.check[1],
            termID: search.termID,
          );
          await getUserDetailData(search.userDetail!);

          Get.back();

          await showMySnackbar(message: "유저 정보 수정에 성공했습니다.");
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
        myTextInput("비밀번호", reset.edit1, isMandatory: true),
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
            userType: search.userType?.index,
            status: search.check[1],
            termID: search.termID,
          );
          await getUserDetailData(search.userDetail!);

          Get.back();

          await showMySnackbar(message: "비밀번호 초기화에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }
}
