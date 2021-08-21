import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/widget/single_reusable.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Container(
      height: 100.r,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(1, 50, 32, 1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 24.r),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                    child: GetBuilder<DataController>(
                      builder: (controller) {
                        return Text(
                          "${controller.profile.userID}님",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.r,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                    child: Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 48.r,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/scan");
                    },
                    child: Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 48.r,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 0, 24.r, 0),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/metronome");
                    },
                    child: Icon(
                      CupertinoIcons.metronome,
                      size: 48.r,
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
