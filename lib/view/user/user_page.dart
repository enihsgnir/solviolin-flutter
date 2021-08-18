import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user/user_list.dart';
import 'package:solviolin_admin/view/user/user_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:solviolin_admin/widget/selection.dart';

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
                padding: const EdgeInsets.all(8),
                child: UserSearch(),
              ),
              Expanded(
                child: UserList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
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
                    fontSize: 28,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: input("아이디", id, "아이디를 입력하세요!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: input("비밀번호", pw, "비밀번호를 입력하세요!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: input("이름", name, "이름을 입력하세요!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: input("전화번호", phone, "전화번호를 입력하세요!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 110,
                              child: Text("구분"),
                            ),
                            Container(
                              width: 220,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
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
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: branchDropdown("Register"),
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    ),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: id.text == "" ||
                            pw.text == "" ||
                            name.text == "" ||
                            phone.text == "" ||
                            branch.branchName == null
                        ? null
                        : () async {
                            try {
                              await client.registerUser(
                                userID: id.text,
                                userPassword: pw.text,
                                userName: name.text,
                                userPhone: phone.text,
                                userType: _parseUserType(type),
                                userBranch: branch.branchName!,
                              );
                            } catch (e) {
                              showErrorMessage(context, e.toString());
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(96, 128, 104, 100),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    ),
                    child: Text(
                      "등록",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

enum UserType {
  student,
  teacher,
  admin,
}

int _parseUserType(UserType type) {
  Map<UserType, int> _type = {
    UserType.student: 0,
    UserType.teacher: 1,
    UserType.admin: 2,
  };

  return _type[type]!;
}
