import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/single.dart';

class TermPage extends StatefulWidget {
  const TermPage({Key? key}) : super(key: key);

  @override
  _TermPageState createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var register = Get.put(CacheController(), tag: "/register");
  var update = Get.put(CacheController(), tag: "/update");
  var extend = Get.put(CacheController(), tag: "/extend");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar(
          "학기",
          actions: [
            IconButton(
              onPressed: () => showLoading(() async {
                await _data.setTerms();
                _data.update();
              }),
              icon: Icon(Icons.refresh_outlined, size: 28.r),
            ),
          ],
        ),
        body: SafeArea(
          child: _termList(),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(32.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                child: Icon(Icons.menu, size: 36.r),
                heroTag: null,
                onPressed: _showMenu,
              ),
              FloatingActionButton(
                child: Icon(Icons.add, size: 36.r),
                heroTag: null,
                onPressed: _showRegister,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _termList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: _data.terms.length,
          itemBuilder: (context, index) {
            var term = _data.terms[index];

            return mySlidableCard(
              slideActions: [
                mySlideAction(
                    context: context,
                    icon: CupertinoIcons.pencil,
                    item: "수정",
                    onTap: () {
                      update.reset();

                      showMyDialog(
                        title: "학기 수정",
                        contents: [
                          pickDate(
                            context: context,
                            item: "시작일",
                            tag: "/update",
                            index: 0,
                            isMandatory: true,
                          ),
                          pickDate(
                            context: context,
                            item: "종료일",
                            tag: "/update",
                            index: 1,
                            isMandatory: true,
                          ),
                        ],
                        onPressed: () => showLoading(() async {
                          try {
                            await _client.modifyTerm(
                              term.id,
                              termStart: update.date[0]!,
                              termEnd: update.date[1]!,
                            );

                            await _data.setTerms();
                            _data.update();

                            Get.back();

                            await showMySnackbar(
                              message: "학기 수정에 성공했습니다.",
                            );
                          } catch (e) {
                            showError(e);
                          }
                        }),
                      );
                    }),
              ],
              children: [
                Text(term.toString()),
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
      title: "학기 등록",
      contents: [
        pickDate(
          context: context,
          item: "시작일",
          tag: "/register",
          index: 0,
          isMandatory: true,
        ),
        pickDate(
          context: context,
          item: "종료일",
          tag: "/register",
          index: 1,
          isMandatory: true,
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerTerm(
            termStart: register.date[0]!,
            termEnd: register.date[1]!,
          );

          await _data.setTerms();
          _data.update();

          Get.back();

          await showMySnackbar(
            message: "신규 학기 등록에 성공했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
    );
  }

  Future _showMenu() {
    FocusScope.of(context).requestFocus(FocusNode());

    return showMyModal(
      context: context,
      message: "수업을 다음 학기로 연장하시겠습니까?",
      children: ["정기 연장 (지점)", "정기 연장 (수강생)"],
      isDestructiveAction: [false, false],
      onPressed: [_showExtendOfBranch, _showExtendOfUser],
    );
  }

  Future _showExtendOfBranch() {
    extend.reset();
    extend.branchName = _data.profile.branchName;

    return showMyDialog(
      title: "정기 연장 (지점)",
      contents: [
        branchDropdown("/extend", true),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.extendAllCoursesOfBranch(extend.branchName!);

          Get.until(ModalRoute.withName("/term"));
          await showMySnackbar(
            message: "해당 지점의 모든 수업을 다음 학기로 연장했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
    );
  }

  Future _showExtendOfUser() {
    extend.reset();

    return showMyDialog(
      title: "정기 연장 (수강생)",
      contents: [
        myTextInput("이름", extend.edit1, isMandatory: true),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.extendAllCoursesOfUser(textEdit(extend.edit1)!);

          Get.until(ModalRoute.withName("/term"));
          await showMySnackbar(
            message: "해당 수강생의 모든 수업을 다음 학기로 연장했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }
}
