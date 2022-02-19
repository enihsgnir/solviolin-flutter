import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var _id = TextEditingController();
  var _pw = TextEditingController();
  var _autoLogin = true;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180.r,
                height: 180.r,
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: const AssetImage("assets/solviolin_logo.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12.r),
                child: Text(
                  "솔바이올린 수강생용",
                  style: TextStyle(color: Colors.white, fontSize: 28.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.r, 30.r, 8.r, 8.r),
                child: TextField(
                  controller: _id,
                  decoration: InputDecoration(
                    labelText: "아이디",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _id.clear,
                      icon: Icon(Icons.clear, size: 20.r),
                      splashRadius: 20.r,
                    ),
                  ),
                  style: contentStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.r),
                child: TextField(
                  controller: _pw,
                  decoration: InputDecoration(
                    labelText: "비밀번호",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _pw.clear,
                      icon: Icon(Icons.clear, size: 20.r),
                      splashRadius: 20.r,
                    ),
                  ),
                  style: contentStyle,
                  obscureText: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "자동로그인",
                    style: TextStyle(color: Colors.white, fontSize: 20.r),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: CupertinoSwitch(
                      value: _autoLogin,
                      onChanged: (value) {
                        setState(() {
                          _autoLogin = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 60.r,
                margin: EdgeInsets.all(16.r),
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    showLoading(() async {
                      try {
                        _data.profile = await _client.login(
                          userID: textEdit(_id)!,
                          userPassword: textEdit(_pw)!,
                          autoLogin: _autoLogin,
                        );
                        await _data.getInitialData();
                        await _data.setTerms();

                        Get.offAllNamed("/menu");
                        await showMySnackbar(
                          title: "${_data.profile.userID}님",
                          message: !_data.isRegularScheduleExisting
                              ? "정기수업이 시작되지 않아 예약가능한 시간대가 표시되지 않습니다. 관리자에게 문의하세요."
                              : "환영합니다!",
                        );
                      } catch (e) {
                        showError(e);
                        _pw.clear();
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: symbolColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "로그인",
                    style: TextStyle(color: Colors.white, fontSize: 24.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
