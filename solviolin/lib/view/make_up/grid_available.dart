import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';

class GridAvailable extends StatefulWidget {
  const GridAvailable({Key? key}) : super(key: key);

  @override
  _GridAvailableState createState() => _GridAvailableState();
}

class _GridAvailableState extends State<GridAvailable> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (controller) {
        if (!controller.isRegularScheduleExisting) {
          return _warning("수업시간 변경이 필요하시면\n010-6684-8224로 문의바랍니다.");
        } else if (controller.selectedDay.isBefore(DateTime.now().midnight)) {
          return _warning("오늘보다 이전 날짜에는 예약할 수 없습니다!");
        } else if (controller.availabaleSpots.isEmpty) {
          return _warning("예약가능한 시간대가 없습니다!");
        } else {
          return Expanded(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 0),
              crossAxisCount: 4,
              mainAxisSpacing: 16.r,
              crossAxisSpacing: 8.r,
              childAspectRatio: 2.2,
              children: List.generate(
                controller.availabaleSpots.length,
                (index) => InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: symbolColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      formatTime(controller.availabaleSpots[index]),
                      style: contentStyle,
                    ),
                  ),
                  onTap: () async {
                    if (controller.availabaleSpots[index]
                        .isAfter(controller.currentTerm[1].termEnd)) {
                      await showError("다음 학기의 수업 예약은 해당 학기에 가능합니다.");
                    } else {
                      await _showReserve(controller.availabaleSpots[index]);
                    }
                  },
                  enableFeedback: false,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _warning(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.r),
        child: Text(
          text,
          style: TextStyle(color: Colors.red, fontSize: 22.r),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future _showReserve(DateTime time) {
    var _regular = _data.regularSchedules[0];
    var _duration = _regular.endTime - _regular.startTime;

    return showMyModal(
      context: context,
      title: formatDateTimeRange(time, time.add(_duration)),
      message: "예약 하시겠습니까?",
      child: "예약",
      onPressed: () => showLoading(() async {
        try {
          await _client.makeUp(
            teacherID: _data.regularSchedules[0].teacherID,
            branchName: _data.profile.branchName,
            startDate: time,
            endDate: time.add(_duration),
            userID: _data.profile.userID,
          );

          await _data.getInitialData();
          await _data.getSelectedDayData(_data.selectedDay);
          await _data.getChangedPageData(_data.focusedDay);

          Get.back();

          await showMySnackbar(message: "수업 예약에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
    );
  }
}
