import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/widget/dialog.dart';

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
      padding: EdgeInsets.symmetric(vertical: 24.r),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(1, 50, 32, 1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 24.r),
                  child: InkWell(
                    onTap: () => showLoading(() async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showError(e);
                      }
                    }),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: InkWell(
                    onTap: () => showLoading(() async {
                      try {
                        await getReservedHistoryData();
                        Get.toNamed("/history");
                      } catch (e) {
                        showError(e);
                      }
                    }),
                    child: Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 48.r,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: InkWell(
                    onTap: () => Get.toNamed("/check-in"),
                    child: Icon(Icons.qr_code_scanner_outlined, size: 48.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 0, 24.r, 0),
                  child: InkWell(
                    onTap: () => Get.toNamed("/metronome"),
                    child: Icon(CupertinoIcons.metronome, size: 48.r),
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
