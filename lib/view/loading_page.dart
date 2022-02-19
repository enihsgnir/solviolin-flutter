import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';

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
        _data.profile = await _client.getProfile();
        _data.branches = await _client.getBranches();
        await _data.setTerms();

        if (_data.profile.userType == 2) {
          Get.offAllNamed("/menu");
        } else if (_data.profile.userType == 1) {
          await _data.getInitialForTeacherData();
          Get.offAllNamed("/menu-teacher");
        }

        await showMySnackbar(
          title: "${_data.profile.userID}님",
          message: "환영합니다!",
        );
      } catch (e) {
        try {
          if (!(e is NetworkException && e.isTimeout)) {
            await _client.logout();
          }
        } catch (_) {}

        Get.offAllNamed("/login");
        showError(e);
      }
    } else {
      await _client.logout();
      Get.offAllNamed("/login");
    }
  }
}
