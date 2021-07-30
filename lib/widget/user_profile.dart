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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    Get.find<DataController>();

    return Container(
      height: deviceHeight * 0.07,
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
                  InkWell(
                    onTap: () {
                      Get.toNamed("/history");
                    },
                    child: GetBuilder<DataController>(
                      builder: (controller) {
                        return Text(
                          "${controller.user.userName}님",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/history");
                  },
                  child: Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    size: deviceHeight * 0.04,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/scan");
                  },
                  child: Icon(
                    Icons.qr_code_scanner_outlined,
                    size: deviceHeight * 0.04,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/metronome");
                  },
                  child: Icon(
                    CupertinoIcons.metronome,
                    size: deviceHeight * 0.04,
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: InkWell(
              //     onTap: () {
              //       Get.put(Client()).logout();
              //       Get.offAllNamed("/login");
              //     },
              //     child: Icon(
              //       Icons.logout_outlined,
              //       size: deviceHeight * 0.04,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
