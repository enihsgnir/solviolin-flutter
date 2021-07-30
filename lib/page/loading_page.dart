import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
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
    Future.delayed(Duration(seconds: 2), () async {
      await deleteTokenForTest();
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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: deviceHeight * 0.3,
                width: deviceHeight * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/solviolin_logo.png"),
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
                    color: Theme.of(context).accentColor,
                    fontSize: 120,
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
      Get.find<DataController>().updateUser(await client.getProfile());
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
