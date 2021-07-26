import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () => _deleteTokenForTest());
    Future.delayed(Duration(seconds: 2), () => _checkUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
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
                padding: EdgeInsets.only(top: 30),
                child: Text("솔바이올린"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkUser() async {
    Client client = Get.put(Client());
    if (await client.isLoggedIn()) {
      Get.find<DataController>().updateUser(await client.getProfile());
      await getUserBaseData();
      await Get.offAllNamed("/main");
    } else {
      Get.offAllNamed("/login");
    }
  }

  Future<void> _deleteTokenForTest() async {
    await Get.put(Client()).storage.deleteAll();
  }
}
