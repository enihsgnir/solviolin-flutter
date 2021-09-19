import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var id = TextEditingController();
  var pw = TextEditingController();

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
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
                  "솔바이올린 강사/관리자용",
                  style: TextStyle(color: Colors.white, fontSize: 28.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.r, 30.r, 8.r, 8.r),
                child: TextFormField(
                  controller: id,
                  decoration: const InputDecoration(
                    labelText: "아이디",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: contentStyle,
                  validator: (value) => value == null ? "아이디를 입력해주세요" : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.r),
                child: TextFormField(
                  controller: pw,
                  decoration: const InputDecoration(
                    labelText: "비밀번호",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: contentStyle,
                  obscureText: true,
                  validator: (value) => value == null ? "비밀번호를 입력해주세요" : null,
                ),
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
                        _data.reset();
                        await getInitialData(false, id.text, pw.text);
                        if (_data.profile.userType == 2) {
                          Get.offAllNamed("/menu");
                        } else if (_data.profile.userType == 1) {
                          Get.offAllNamed("/menu-teacher");
                        }

                        await showMySnackbar(
                          title: "${_data.profile.userID}님",
                          message: "환영합니다!",
                        );
                      } catch (e) {
                        try {
                          await _client.logout();
                        } catch (_) {
                        } finally {
                          showError(e);
                          pw.text = "";
                        }
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: symbolColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "로그인",
                    style: TextStyle(color: Colors.white, fontSize: 24.r),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
