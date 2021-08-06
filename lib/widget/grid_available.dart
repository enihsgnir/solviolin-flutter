import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/notification.dart';

class GridAvailable extends StatefulWidget {
  const GridAvailable({Key? key}) : super(key: key);

  @override
  _GridAvailableState createState() => _GridAvailableState();
}

class _GridAvailableState extends State<GridAvailable> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.selectedDay.isBefore(kToday)
            ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    "오늘보다 이전 날짜에는 예약할 수 없습니다!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.sp,
                    ),
                  ),
                ),
              )
            : controller.availabaleSpots.length == 0
                ? Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Text(
                        "예약가능한 시간대가 없습니다!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    crossAxisCount: 4,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 2,
                    children: List<Widget>.generate(
                      controller.availabaleSpots.length,
                      (index) => InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(96, 128, 104, 100),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Text(
                            "${dateTimeToTimeString(controller.availabaleSpots[index])}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await showModalReserve(
                            context,
                            controller.availabaleSpots[index],
                          );
                        },
                        enableFeedback: false,
                      ),
                    ),
                  );
      },
    );
  }
}
