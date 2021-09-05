import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Client _client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      // await _client.logout(); // for test

      try {
        await checkProfile();
      } catch (e) {
        try {
          await _client.logout();
        } catch (e) {} finally {
          Get.offAllNamed("/login");
          showError(e.toString());
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.updateRatio(
      min(MediaQuery.of(context).size.width / 540,
          MediaQuery.of(context).size.height / 1152),
    );
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
                padding: EdgeInsets.only(top: 30.r),
                child: Text(
                  "솔바이올린",
                  style: TextStyle(color: Colors.white, fontSize: 40.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkProfile() async {
    if (await _client.isLoggedIn()) {
      await getInitialData();
      if (_controller.profile.userType == 2) {
        Get.offAllNamed("/menu");
      } else if (_controller.profile.userType == 1) {
        Get.offAllNamed("/menu-teacher");
      }
    } else {
      try {
        await _client.logout();
      } catch (e) {} finally {
        Get.offAllNamed("/login");
      }
    }
  }
}
