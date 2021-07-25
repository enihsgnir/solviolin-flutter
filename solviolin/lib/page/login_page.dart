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
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final _textHeight = _deviceHeight / MediaQuery.of(context).textScaleFactor;
    Client client = Get.put(Client());
    DataController _controller = Get.find<DataController>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/solviolin_logo.png"),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "아이디",
                  hintText: "아이디",
                ),
                validator: (value) {
                  return (value == null) ? "아이디를 입력해주세요" : null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _pwController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호",
                  hintText: "비밀번호",
                ),
                validator: (value) {
                  return (value == null) ? "비밀번호를 입력해주세요" : null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Container(
                height: 45,
                child: Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      _controller.updateUser(await client.login(
                          _idController.text, _pwController.text));
                      await getUserBaseData(context);
                      await _controller.checkAllComplete()
                          ? Get.offAllNamed("/main")
                          : showErrorMessage(context);

                      // Get.offAllNamed("/test");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(96, 128, 104, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        color: const Color.fromRGBO(203, 173, 204, 80),
                        fontSize: 15,
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
