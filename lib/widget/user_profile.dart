import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/notification.dart';

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
      height: 100.h,
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
                  padding: const EdgeInsets.only(left: 24),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showErrorMessage(context, e.toString());
                      }
                    },
                    child: GetBuilder<DataController>(
                      builder: (controller) {
                        return Text(
                          "${controller.user.userID}님",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showErrorMessage(context, e.toString());
                      }
                    },
                    child: Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 48.r,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  padding: EdgeInsets.only(left: 16.w, right: 24),
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
