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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: _showUserRegister,
        ),
      ),
    );
  }

  Widget _userSearch() {
    return mySearch(
      contents: [
        myTextInput("이름", search.edit1),
        branchDropdown("/search/user"),
        myRadio<UserType>(
          tag: "/search/user",
          item: "구분",
          names: ["수강생", "강사", "관리자"],
          values: UserType.values,
          groupValue: UserType.student,
        ),
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
                  await saveUsersData(
                    branchName: search.branchName,
                    userID: textEdit(search.edit1),
                    isPaid: search.check[0],
                    userType: UserType.values.indexOf(search.type[UserType]),
                    status: search.check[1],
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
                  await getUsersData(
                    branchName: search.branchName,
                    userID: textEdit(search.edit1),
                    isPaid: search.check[0],
                    userType: UserType.values.indexOf(search.type[UserType]),
                    status: search.check[1],
                  );

                  search.isSearched = true;

                  if (_data.users.length == 0) {
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
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.users.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("목록은 검색 입력값을 기반으로 저장됩니다."),
                    Text("저장하기 전 검색을 권장합니다."),
                    Text("\n유저 목록 파일 저장 경로"),
                    Text("\nAndroid: 내장 메모리/Android/data/"),
                    Text("/com.solviolin.solviolin_admin/files/"),
                    Text("\niOS: 파일/나의 iPhone(iPad)/"),
                    Text("솔바이올린(관리자)/"),
                  ], //TODO:
                ),
              )
            : ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  var user = controller.users[index];

                  return InkWell(
                    child: myNormalCard(
                      padding: EdgeInsets.symmetric(vertical: 8.r),
                      children: [
                        Text("${user.userID} / ${user.branchName}"),
                        Text(_parsePhoneNumber(user.userPhone)),
                        Text("${user.status == 0 ? "미등록" : "등록"}" +
                            " / 크레딧: ${user.userCredit}"),
                        Text(_ledgerToString(user.paidAt)),
                      ],
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showLoading(() async {
                        try {
                          await getUserDetailData(user);
                          search.userDetail = user;
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

    return showMyDialog(
      title: "유저 신규 등록",
      contents: [
        myTextInput("아이디", register.edit1, "아이디를 입력하세요!"),
        myTextInput("비밀번호", register.edit2, "비밀번호를 입력하세요!"),
        myTextInput("이름", register.edit3, "이름을 입력하세요!"),
        myTextInput(
            "전화번호", register.edit4, "전화번호를 입력하세요!", TextInputType.number),
        branchDropdown("/register", "지점을 선택하세요!"),
        myRadio<UserType>(
          tag: "/register",
          item: "구분",
          names: ["수강생", "강사", "관리자"],
          values: UserType.values,
          groupValue: UserType.student,
        ),
      ],
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        showMyDialog(
          title: "입력하신 정보가 맞습니까?",
          contents: [
            Text("아이디: " + register.edit1.text),
            Text("비밀번호: " + register.edit2.text),
            Text("이름: " + register.edit3.text),
            Text("전화번호: " + register.edit4.text),
            Text("구분: " + register.type[UserType].toString()),
            Text("지점: " + (register.branchName ?? "")),
            Text(
              "\n아이디는 등록 후 변경할 수 없습니다.",
              style: TextStyle(color: Colors.red, fontSize: 16.r),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.registerUser(
                userID: textEdit(register.edit1)!,
                userPassword: textEdit(register.edit2)!,
                userName: textEdit(register.edit3)!,
                userPhone: textEdit(register.edit4)!,
                userType: UserType.values.indexOf(register.type[UserType]),
                userBranch: register.branchName!,
              );

              if (search.isSearched) {
                await getUsersData(
                  branchName: search.branchName,
                  userID: textEdit(search.edit1),
                  isPaid: search.check[0],
                  userType: UserType.values.indexOf(search.type[UserType]),
                  status: search.check[1],
                );
              }

              Get.back();
              Get.back();

              await showMySnackbar(
                message: "유저 신규 등록에 성공했습니다.",
              );
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
}

String _parsePhoneNumber(String phone) {
  if (phone.length == 10) {
    return phone.replaceAllMapped(
      RegExp(r"(\d{3})(\d{3})(\d+)"),
      (match) => "${match[1]}-${match[2]}-${match[3]}",
    );
  } else if (phone.length == 11) {
    return phone.replaceAllMapped(
      RegExp(r"(\d{3})(\d{4})(\d+)"),
      (match) => "${match[1]}-${match[2]}-${match[3]}",
    );
  } else if (phone.length > 3) {
    return phone.replaceAllMapped(
      RegExp(r"(\d{3})(\d+)"),
      (match) => "${match[1]}-${match[2]}",
    );
  } else {
    return phone;
  }
}

String _ledgerToString(List<DateTime> paidAt) => paidAt.length == 0
    ? "이번 학기 결제 미완료"
    : "결제일: " + DateFormat("yy/MM/dd HH:mm").format(paidAt[0]);
