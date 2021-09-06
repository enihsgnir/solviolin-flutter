import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/user/user_list.dart';
import 'package:solviolin_admin/view/user/user_search.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/single.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Client client = Get.find<Client>();

  var id = TextEditingController();
  var pw = TextEditingController();
  var name = TextEditingController();
  var phone = TextEditingController();
  var type = Get.put(RadioController<UserType>(), tag: "Register");
  var branch = Get.put(BranchController(), tag: "Register");

  var search = Get.find<SearchController>(tag: "User");

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
        appBar: myAppBar("유저"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: UserSearch(),
              ),
              myDivider(),
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
    return showMyDialog(
      context: context,
      title: "유저 신규 등록",
      contents: [
        myTextInput("아이디", id, "아이디를 입력하세요!"),
        myTextInput("비밀번호", pw, "비밀번호를 입력하세요!"),
        myTextInput("이름", name, "이름을 입력하세요!"),
        myTextInput("전화번호", phone, "전화번호를 입력하세요!"),
        myRadio<UserType>(
          tag: "Register",
          item: "구분",
          names: ["수강생", "강사", "관리자"],
          values: [UserType.student, UserType.teacher, UserType.admin],
          groupValue: UserType.student,
        ),
        branchDropdown("Register", "지점을 선택하세요!"),
      ],
      onPressed: () async {
        try {
          await client.registerUser(
            userID: id.text,
            userPassword: pw.text,
            userName: name.text,
            userPhone: phone.text,
            userType: type.type == UserType.student
                ? 0
                : type.type == UserType.teacher
                    ? 1
                    : 2,
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

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }
}
