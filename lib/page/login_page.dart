import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/notification.dart';

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
    final deviceHeight = MediaQuery.of(context).size.height;

    Client client = Get.put(Client());
    DataController _controller = Get.find<DataController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: deviceHeight * 0.16,
              height: deviceHeight * 0.16,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/solviolin_logo.png"),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "아이디",
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 22,
                ),
                validator: (value) {
                  return (value == null) ? "아이디를 입력해주세요" : null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: pwController,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 22,
                ),
                obscureText: true,
                validator: (value) {
                  return (value == null) ? "비밀번호를 입력해주세요" : null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Container(
                height: deviceHeight * 0.05,
                child: Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        _controller.updateUser(await client.login(
                            idController.text, pwController.text));
                        await getUserBasedData();
                        Get.offAllNamed("/main");

                        //await Get.offAllNamed("/test");
                      } catch (e) {
                        Get.offAllNamed("/login");
                        showErrorMessage(context, e.toString());
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(96, 128, 104, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "로그인",
                      style: TextStyle(
                        color: const Color.fromRGBO(203, 173, 204, 80),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
