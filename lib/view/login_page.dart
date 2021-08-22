import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/single_reusable.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Client client = Get.find<Client>();

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextStyle(color: Colors.white, fontSize: 20.r),
                validator: (value) {
                  return (value == null) ? "아이디를 입력해주세요" : null;
                },
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
                style: TextStyle(color: Colors.white, fontSize: 20.r),
                obscureText: true,
                validator: (value) {
                  return (value == null) ? "비밀번호를 입력해주세요" : null;
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 60.r,
              margin: EdgeInsets.all(16.r),
              child: TextButton(
                onPressed: () async {
                  try {
                    await getInitialData(false, id.text, pw.text);
                    Get.offAllNamed("/main");
                  } catch (e) {
                    await client.logout();
                    Get.offAllNamed("/login");
                    showError(context, e.toString());
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: symbolColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  "로그인",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.r,
                    fontWeight: FontWeight.bold,
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
