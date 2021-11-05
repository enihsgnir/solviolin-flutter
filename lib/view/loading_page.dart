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
  var _data = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      await _checkProfile();
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

        var message = "환영합니다!";
        if (!_data.isRegularScheduleExisting) {
          message = "정기수업이 시작되지 않아 예약가능한 시간대가 표시되지 않습니다. 관리자에게 문의하세요.";
        }
        await showMySnackbar(
          title: "${_data.profile.userID}님",
          message: message,
        );
      } catch (e) {
        try {
          await _client.logout();
        } catch (_) {
        } finally {
          Get.offAllNamed("/login");
          showError(e);
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
