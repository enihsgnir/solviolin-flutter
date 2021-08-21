import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user/user_list.dart';
import 'package:solviolin_admin/view/user/user_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Client client = Get.find<Client>();

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");

  UserType type = UserType.student;

  SearchController search = Get.find<SearchController>(tag: "User");

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("유저"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: UserSearch(),
              ),
              Expanded(
                child: UserList(),
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

  Future _showUserRegister() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: AlertDialog(
                title: Text(
                  "유저 신규 등록",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.r,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: input("아이디", id, "아이디를 입력하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: input("비밀번호", pw, "비밀번호를 입력하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: input("이름", name, "이름을 입력하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: input("전화번호", phone, "전화번호를 입력하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.r,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 110,
                              child: label("구분", true),
                            ),
                            Container(
                              width: 220.r,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    child: Column(
                                      children: [
                                        Text("수강생"),
                                        Radio(
                                          value: UserType.student,
                                          groupValue: type,
                                          onChanged: (UserType? value) {
                                            setState(() {
                                              type = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    child: Column(
                                      children: [
                                        Text("강사"),
                                        Radio(
                                          value: UserType.teacher,
                                          groupValue: type,
                                          onChanged: (UserType? value) {
                                            setState(() {
                                              type = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    child: Column(
                                      children: [
                                        Text("관리자"),
                                        Radio(
                                          value: UserType.admin,
                                          groupValue: type,
                                          onChanged: (UserType? value) {
                                            setState(() {
                                              type = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: branchDropdown("Register", "지점을 선택하세요!"),
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                    ),
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.white, fontSize: 20.r),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await client.registerUser(
                          userID: id.text,
                          userPassword: pw.text,
                          userName: name.text,
                          userPhone: phone.text,
                          userType: _parseUserType(type),
                          userBranch: branch.branchName!,
                        );

                        if (search.isSearched) {
                          await getUsersData(
                            branchName: search.text1,
                            userID: search.text2,
                            isPaid: search.number1,
                            status: search.number2,
                          );
                        }
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: symbolColor,
                      padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                    ),
                    child: Text("등록", style: TextStyle(fontSize: 20.r)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _parseUserType(UserType type) {
    Map<UserType, int> _type = {
      UserType.student: 0,
      UserType.teacher: 1,
      UserType.admin: 2,
    };

    return _type[type]!;
  }
}

enum UserType {
  student,
  teacher,
  admin,
}
