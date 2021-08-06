import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Client client = Get.put(Client());

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      // await client.logout(); // for test

      try {
        await checkUser();
      } catch (e) {
        await client.logout();
        Get.offAllNamed("/login");
        showErrorMessage(context, e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180.r,
                width: 180.r,
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: const AssetImage("assets/solviolin_logo.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "솔바이올린",
                  style: TextStyle(color: Colors.white, fontSize: 40.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUser() async {
    if (await client.isLoggedIn()) {
      await getInitialData();
      Get.offAllNamed("/main");
    } else {
      await client.logout();
      Get.offAllNamed("/login");
    }
  }
}
