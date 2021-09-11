import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      // await _client.logout(); // for test

      await _checkProfile();
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

  Future<void> _checkProfile() async {
    if (await _client.isLoggedIn()) {
      try {
        await getInitialData();
        Get.offAllNamed("/main");
      } catch (e) {
        try {
          await _client.logout();
        } catch (_) {
        } finally {
          Get.offAllNamed("/login");
          showError(e.toString());
        }
      }
    } else {
      try {
        await _client.logout();
      } catch (_) {
      } finally {
        Get.offAllNamed("/login");
      }
    }
  }
}
