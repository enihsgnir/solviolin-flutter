import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/notification.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  Get.offAllNamed("/main");
                },
                child: Text(
                  "MainPage",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    throw "해당 시간에 이미 수업이 존재합니다. 다시 시도해 주세요.";
                  } catch (e) {
                    showErrorMessage(context, e.toString());
                  }
                },
                child: Text(
                  "Show Error Message",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
