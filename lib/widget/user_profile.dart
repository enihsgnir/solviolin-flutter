import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    Get.find<DataController>();

    return Container(
      height: deviceHeight * 0.09,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(1, 50, 32, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 24),
                  child: InkWell(
                    onTap: () async {
                      await getReservationHistoryData();
                      Get.toNamed("/history");
                    },
                    child: GetBuilder<DataController>(
                      builder: (controller) {
                        return Text(
                          "${controller.user.userName}님",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () async {
                      await getReservationHistoryData();
                      Get.toNamed("/history");
                    },
                    child: Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 48,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/scan");
                    },
                    child: Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 48,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 24),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/metronome");
                    },
                    child: Icon(
                      CupertinoIcons.metronome,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
