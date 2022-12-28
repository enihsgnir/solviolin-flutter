import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/user");
  var register = Get.put(CacheController(), tag: "/register");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: myAppBar("유저 검색"),
        body: SafeArea(
          child: Column(
            children: [
              _userSearch(),
              myDivider(),
              Expanded(
                child: _userList(),
              ),
            ],
          ),
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
                onPressed: _showUserRegister,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _userSearch() {
    return mySearch(
      contents: [
        myTextInput("이름", search.edit1),
        branchDropdown("/search/user"),
        termDropdown("/search/user"),
        userTypeDropdown("/search/user"),
        Row(
          children: [
            myCheckBox(
              tag: "/search/user",
              index: 1,
              item: "등록 여부",
              trueName: "등록",
              falseName: "미등록",
            ),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await _data.saveUsersData(
                    branchName: search.branchName,
                    userID: textEdit(search.edit1),
                    isPaid: search.check[0],
                    userType: search.userType?.index,
                    status: search.check[1],
                    termID: search.termID,
                  );
                } catch (e) {
                  showError(e);
                }
              }),
              action: "저장",
            ),
          ],
        ),
        Row(
          children: [
            myCheckBox(
              tag: "/search/user",
              index: 0,
              item: "결제 여부",
              trueName: "완료",
              falseName: "미완료",
            ),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await _data.getUsersData(
                    branchName: search.branchName,
                    userID: textEdit(search.edit1),
                    isPaid: search.check[0],
                    userType: search.userType?.index,
                    status: search.check[1],
                    termID: search.termID,
                  );

                  search.isSearched = true;

                  if (_data.users.isEmpty) {
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

  Widget _userList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return _data.users.isEmpty
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                textAlign: TextAlign.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "목록은 검색 입력값을 기반으로 저장됩니다." +
                          "\n저장하기 전 검색을 통해 목록을 확인하세요." +
                          "\n\n유저 목록 파일(*.xlsx) 저장 경로:" +
                          (Platform.isIOS
                              ? "\n파일/나의 iPhone(iPad)/솔바이올린(관리자)/"
                              : "\n내장 메모리/Android/data/com.solviolin.solviolin_admin/files/"),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _data.users.length,
                itemBuilder: (context, index) {
                  var user = _data.users[index];

                  return InkWell(
                    child: myNormalCard(
                      padding: EdgeInsets.symmetric(vertical: 8.r),
                      children: [
                        Text(user.toString()),
                      ],
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showLoading(() async {
                        try {
                          search.userDetail = user;
                          await _data.getUserDetailData(user);

                          Get.toNamed("/user/detail");
                        } catch (e) {
                          showError(e);
                        }
                      });
                    },
                  );
                },
              );
      },
    );
  }

  Future _showUserRegister() {
    FocusScope.of(context).requestFocus(FocusNode());
    register.reset();
    register.branchName = _data.profile.branchName;

    return showMyDialog(
      title: "유저 신규 등록",
      contents: [
        myTextInput("아이디", register.edit1, isMandatory: true),
        myTextInput("비밀번호", register.edit2, isMandatory: true),
        myTextInput("이름", register.edit3, isMandatory: true),
        myTextInput(
          "전화번호",
          register.edit4,
          isMandatory: true,
          keyboardType: TextInputType.number,
          hintText: "01012345678",
        ),
        branchDropdown("/register", true),
        userTypeDropdown("/register", true),
      ],
      onPressed: () {
        showMyDialog(
          title: "입력하신 정보가 맞습니까?",
          contents: [
            Text("아이디: ${register.edit1.text}" +
                "\n비밀번호: ${register.edit2.text}" +
                "\n이름: ${register.edit3.text}" +
                "\n전화번호: ${formatPhone(register.edit4.text)}" +
                "\n지점: ${register.branchName!}" +
                "\n구분: ${register.userType?.name}"),
            Text(
              "\n아이디는 등록 후 변경할 수 없습니다.",
              style: TextStyle(color: Colors.red, fontSize: 16.r),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              var phone = textEdit(register.edit4);
              if (phone != null) {
                if (!checkPhone(phone)) {
                  throw "올바르지 않은 전화번호 형식입니다.";
                } else {
                  phone = trimPhone(phone);
                }
              }

              await _client.registerUser(
                userID: textEdit(register.edit1)!,
                userPassword: textEdit(register.edit2)!,
                userName: textEdit(register.edit3)!,
                userPhone: phone!,
                userType: register.userType!.index,
                userBranch: register.branchName!,
              );

              if (search.isSearched) {
                await _data.getUsersData(
                  branchName: search.branchName,
                  userID: textEdit(search.edit1),
                  isPaid: search.check[0],
                  userType: search.userType?.index,
                  status: search.check[1],
                  termID: search.termID,
                );
              }
              Get.until(ModalRoute.withName("/user"));
              await showMySnackbar(message: "유저 신규 등록에 성공했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
      action: "등록",
      isScrollable: true,
    );
  }

  Future _showMenu() {
    FocusScope.of(context).requestFocus(FocusNode());

    return showMyModal(
      context: context,
      message: "...",
      children: ["크레딧 초기화"],
      isDestructiveAction: [true],
      onPressed: [_showInitializeCredit],
    );
  }

  Future _showInitializeCredit() {
    return showMyDialog(
      contents: [
        Text("전 지점 등록 수강생의 크레딧을\n모두 초기화 하시겠습니까?"),
      ],
      onPressed: () {
        showMyDialog(
          title: "경고",
          contents: [
            Text("크레딧 초기화를 진행합니다."),
            Text(
              "\n*되돌릴 수 없습니다.*",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.initializeCredit();

              Get.until(ModalRoute.withName("/user"));
              await showMySnackbar(message: "모든 수강생의 크레딧을 초기화 했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
    );
  }
}
