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
    final _deviceHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final _textHeight = _deviceHeight / MediaQuery.of(context).textScaleFactor;
    Get.find<DataController>();
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
                  GetBuilder<DataController>(
                    builder: (controller) {
                      return Text(
                        "${controller.user.userName}님",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _textHeight * 0.035,
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
                        fontSize: _textHeight * 0.015,
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
                child: Icon(
                  Icons.qr_code_scanner_outlined,
                  size: _deviceHeight * 0.04,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/payment");
                },
                child: Icon(
                  Icons.payment_outlined,
                  size: _deviceHeight * 0.04,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/settings");
                },
                child: Icon(
                  Icons.settings_outlined,
                  size: _deviceHeight * 0.04,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/metronome");
                },
                child: Icon(
                  CupertinoIcons.metronome,
                  size: _deviceHeight * 0.04,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.logout_outlined,
                  size: _deviceHeight * 0.04,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
