import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/single_reusable.dart';

class GridAvailable extends StatefulWidget {
  const GridAvailable({Key? key}) : super(key: key);

  @override
  _GridAvailableState createState() => _GridAvailableState();
}

class _GridAvailableState extends State<GridAvailable> {
  Client _client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.selectedDay.isBefore(kToday)
            ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 40.r),
                  child: Text(
                    "오늘보다 이전 날짜에는 예약할 수 없습니다!",
                    style: TextStyle(color: Colors.red, fontSize: 22.r),
                  ),
                ),
              )
            : controller.availabaleSpots.length == 0
                ? Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 40.r),
                      child: Text(
                        "예약가능한 시간대가 없습니다!",
                        style: TextStyle(color: Colors.red, fontSize: 22.r),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 0),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16.r,
                      crossAxisSpacing: 8.r,
                      childAspectRatio: 2.2,
                      children: List<Widget>.generate(
                        controller.availabaleSpots.length,
                        (index) => InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: symbolColor,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(
                              DateFormat("HH:mm")
                                  .format(controller.availabaleSpots[index]),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.r),
                            ),
                          ),
                          onTap: () async {
                            await _showReserve(
                              context,
                              controller.availabaleSpots[index],
                            );
                          },
                          enableFeedback: false,
                        ),
                      ),
                    ),
                  );
      },
    );
  }

  Future _showReserve(BuildContext context, DateTime time) {
    Duration _duration = _controller.regularSchedules[0].endTime -
        _controller.regularSchedules[0].startTime;

    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          DateFormat("yy/MM/dd HH:mm").format(time) +
              " ~ " +
              DateFormat("HH:mm").format(time.add(_duration)),
          style: TextStyle(fontSize: 24.r),
        ),
        message: Text("예약 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              try {
                await _client.makeUpReservation(
                  teacherID: _controller.regularSchedules[0].teacherID,
                  branchName: _controller.profile.branchName,
                  startDate: time,
                  endDate: time.add(_duration),
                  userID: _controller.profile.userID,
                );

                await getUserBasedData();
                await getSelectedDayData(_controller.selectedDay);
                await getChangedPageData(_controller.focusedDay);

                Get.back();
              } catch (e) {
                showError(context, e.toString());
              }
            },
            child: Text("예약", style: TextStyle(fontSize: 24.r)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24.r)),
        ),
      ),
    );
  }
}
