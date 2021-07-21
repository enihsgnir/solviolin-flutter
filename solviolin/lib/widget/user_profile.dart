import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    Get.put(UserController());
    return Container(
      height: _deviceHeight * 0.07,
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return Text(
                        "${controller.user.userName}님",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed("/history");
                    },
                    child: Text(
                      "내 예약 이력 조회",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed("/scan");
                },
                child: Icon(Icons.qr_code_scanner_outlined),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/payment");
                },
                child: Icon(Icons.payment_outlined),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("settings");
                },
                child: Icon(Icons.settings_outlined),
              ),
              InkWell(
                onTap: () {},
                child: Icon(CupertinoIcons.metronome),
              ),
            ],
          )
        ],
      ),
    );
  }
}
