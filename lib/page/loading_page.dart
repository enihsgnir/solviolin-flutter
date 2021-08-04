import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/util/notification.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      // await deleteTokenForTest();
      try {
        await checkUser();
      } catch (e) {
        Get.offAllNamed("/login");
        showErrorMessage(context, e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: deviceHeight * 0.16,
                width: deviceHeight * 0.16,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/solviolin_logo.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "솔바이올린",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUser() async {
    Client client = Get.put(Client());
    if (await client.isLoggedIn()) {
      await getUserBasedData();
      Get.offAllNamed("/main");
    } else {
      Get.offAllNamed("/login");
    }
  }

  Future<void> deleteTokenForTest() async {
    await Get.put(Client()).storage.deleteAll();
  }
}
