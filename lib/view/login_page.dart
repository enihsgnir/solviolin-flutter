import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: const AssetImage("assets/solviolin_logo.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                child: TextFormField(
                  controller: idController,
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  validator: (value) {
                    return value == null ? "아이디를 입력해주세요" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: pwController,
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  obscureText: true,
                  validator: (value) {
                    return value == null ? "비밀번호를 입력해주세요" : null;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed:
                      idController.text.isEmpty || pwController.text.isEmpty
                          ? null
                          : () async {
                              try {
                                await getInitialData(
                                  isLoggedIn: false,
                                  userID: idController.text,
                                  userPassword: pwController.text,
                                );
                                Get.offAllNamed("/menu");
                              } catch (e) {
                                await logoutAndDeleteData();
                                Get.offAllNamed("/login");
                                showErrorMessage(context, e.toString());
                              }
                            },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(96, 128, 104, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "로그인",
                    style: TextStyle(
                      color: const Color.fromRGBO(203, 173, 204, 80),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
