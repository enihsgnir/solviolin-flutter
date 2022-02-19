import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/control");
  var register = Get.put(CacheController(), tag: "/register");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("오픈/클로즈"),
        body: SafeArea(
          child: Column(
            children: [
              _controlSearch(),
              myDivider(),
              Expanded(
                child: _controlList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: _showRegister,
        ),
      ),
    );
  }

  Widget _controlSearch() {
    if (!search.isSearched) {
      var today = DateTime.now();
      search.date[0] = DateTime(today.year, today.month, today.day - 2);
      search.date[1] = DateTime(today.year, today.month, today.day + 7);
    }

    return mySearch(
      controller: search.expandable,
      contents: [
        branchDropdown("/search/control", true),
        myTextInput("강사", search.edit1),
        pickDate(
          context: context,
          item: "부터",
          tag: "/search/control",
          index: 0,
        ),
        pickDate(
          context: context,
          item: "까지",
          tag: "/search/control",
          index: 1,
        ),
        Row(
          children: [
            myCheckBox(
              tag: "/search/control",
              item: "오픈/클로즈",
              trueName: "오픈",
              falseName: "클로즈",
              isReversed: true,
            ),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await _data.getControlsData(
                    branchName: search.branchName!,
                    teacherID: textEdit(search.edit1),
                    controlStart: search.date[0],
                    controlEnd: search.date[1],
                    status: search.check[0],
                  );

                  search.isSearched = true;
                  search.expandable.expanded = false;

                  if (_data.controls.isEmpty) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e);
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _controlList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: _data.controls.length,
          itemBuilder: (context, index) {
            var control = _data.controls[index];

            return mySlidableCard(
              slideActions: [
                mySlideAction(
                  context: context,
                  icon: CupertinoIcons.delete,
                  item: "삭제",
                  onTap: () => showMyDialog(
                    title: "오픈/클로즈 삭제",
                    contents: [
                      Text("정말 삭제하시겠습니까?"),
                    ],
                    onPressed: () => showLoading(() async {
                      try {
                        await _client.deleteControl(control.id);

                        await _data.getControlsData(
                          branchName: search.branchName!,
                          teacherID: textEdit(search.edit1),
                          controlStart: search.dateTime[0],
                          controlEnd: search.dateTime[1],
                          status: search.check[0],
                        );

                        Get.back();

                        await showMySnackbar(
                          message: "오픈/클로즈 삭제에 성공했습니다.",
                        );
                      } catch (e) {
                        showError(e);
                      }
                    }),
                  ),
                ),
              ],
              children: [
                Text(control.toString()),
              ],
            );
          },
        );
      },
    );
  }

  Future _showRegister() {
    FocusScope.of(context).requestFocus(FocusNode());
    register.reset();
    register.branchName = _data.profile.branchName;

    return showMyDialog(
      title: "오픈/클로즈 등록",
      contents: [
        myTextInput("강사", register.edit1, isMandatory: true),
        branchDropdown("/register", true),
        pickDateTime(
          context: context,
          item: "시작일",
          tag: "/register",
          index: 0,
          isMandatory: true,
        ),
        pickDateTime(
          context: context,
          item: "종료일",
          tag: "/register",
          index: 1,
          isMandatory: true,
        ),
        controlStatusDropdown("/register"),
        cancelInCloseDropdown("/register"),
        Text(
          "*클로즈 등록 시 기간 내 수업 상태 선택",
          style: TextStyle(color: Colors.red, fontSize: 16.r),
        ),
      ],
      onPressed: () {
        void Function() _request = () => showLoading(() async {
              try {
                await _client.registerControl(
                  teacherID: textEdit(register.edit1)!,
                  branchName: register.branchName!,
                  controlStart: register.dateTime[0]!,
                  controlEnd: register.dateTime[1]!,
                  status: register.controlStatus!.index,
                  cancelInClose: register.cancelInClose!.index,
                );

                if (search.isSearched) {
                  await _data.getControlsData(
                    branchName: search.branchName!,
                    teacherID: textEdit(search.edit1),
                    controlStart: search.dateTime[0],
                    controlEnd: search.dateTime[1],
                    status: search.check[0],
                  );
                }

                Get.until(ModalRoute.withName("/control"));
                await showMySnackbar(message: "신규 오픈/클로즈 등록에 성공했습니다.");
              } catch (e) {
                showError(e);
              }
            });

        register.controlStatus == ControlStatus.close &&
                register.cancelInClose == CancelInClose.delete
            ? showMyDialog(
                contents: [
                  Text("클로즈 기간 내 예약을 삭제하시겠습니까?\n취소 내역에 기록되지 않습니다."),
                  Text(
                    "\n*되돌릴 수 없습니다.*" +
                        "\n\n*취소와는 다른 기능입니다.*" +
                        "\n\n*강제로 예약 데이터를 삭제합니다.\n예상치 못한 오류가 발생할 수 있습니다.*" +
                        "\n\n*되도록 권장하지 않습니다.*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
                onPressed: () {
                  showMyDialog(
                    contents: [
                      Text(
                        "정말로 삭제하시겠습니까?",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                    onPressed: () => _request(),
                  );
                },
              )
            : _request();
      },
      action: "등록",
      isScrollable: true,
    );
  }
}
