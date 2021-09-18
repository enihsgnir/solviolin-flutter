import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
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
    return mySearch(
      contents: [
        branchDropdown("/search/control", "지점을 선택하세요!"),
        myTextInput("강사", search.edit1),
        pickDateTime(
          context: context,
          item: "시작일",
          tag: "/search/control",
          index: 0,
        ),
        pickDateTime(
          context: context,
          item: "종료일",
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
                  await getControlsData(
                    branchName: search.branchName!,
                    teacherID: textEdit(search.edit1),
                    controlStart: search.dateTime[0],
                    controlEnd: search.dateTime[1],
                    status: search.check[0],
                  );

                  search.isSearched = true;

                  if (_data.controls.length == 0) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e.toString());
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _controlList() {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.controls.length,
          itemBuilder: (context, index) {
            var control = controller.controls[index];

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

                        await getControlsData(
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
                        showError(e.toString());
                      }
                    }),
                  ),
                ),
              ],
              children: [
                Text("${control.teacherID} / ${control.branchName}" +
                    " / ${control.status == 0 ? "오픈" : "클로즈"}"),
                Text("시작: " +
                    DateFormat("yy/MM/dd HH:mm").format(control.controlStart)),
                Text("종료: " +
                    DateFormat("yy/MM/dd HH:mm").format(control.controlEnd)),
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

    return showMyDialog(
      title: "오픈/클로즈 등록",
      contents: [
        myTextInput("강사", register.edit1, "강사명을 입력하세요!"),
        branchDropdown("/register", "지점을 선택하세요!"),
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
        myRadio<ControlStatus>(
          tag: "/register",
          item: "오픈/클로즈",
          names: ["오픈", "클로즈"],
          values: ControlStatus.values,
          groupValue: ControlStatus.open,
        ),
        myRadio<CancelInClose>(
          tag: "/register",
          item: "기간 내",
          names: ["유지", "취소", "삭제"],
          values: CancelInClose.values,
          groupValue: CancelInClose.none,
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerControl(
            teacherID: textEdit(register.edit1)!,
            branchName: register.branchName!,
            controlStart: register.dateTime[0]!,
            controlEnd: register.dateTime[1]!,
            status: ControlStatus.values.indexOf(register.type[ControlStatus]),
            cancelInClose:
                CancelInClose.values.indexOf(register.type[CancelInClose]),
          );

          if (search.isSearched) {
            await getControlsData(
              branchName: search.branchName!,
              teacherID: textEdit(search.edit1),
              controlStart: search.dateTime[0],
              controlEnd: search.dateTime[1],
              status: search.check[0],
            );
          }

          Get.back();

          await showMySnackbar(
            message: "신규 오픈/클로즈 등록에 성공했습니다.",
          );
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }
}
