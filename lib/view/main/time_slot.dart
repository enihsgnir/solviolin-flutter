import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot extends StatefulWidget {
  const TimeSlot({Key? key}) : super(key: key);

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  Client client = Get.find<Client>();

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();
    CalendarController calendarController = CalendarController();

    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: calendarController,
          onTap: (details) {
            if (details.targetElement == CalendarElement.viewHeader) {
              controller.updateSelectedDay(details.date!);
              if (calendarController.view == CalendarView.week) {
                calendarController.view = CalendarView.timelineDay;
              } else {
                calendarController.view = CalendarView.week;
              }
            } else if (details.targetElement == CalendarElement.calendarCell) {
              _showEmpty(details);
            } else if (details.targetElement == CalendarElement.appointment) {
              _showReserved(details);
            }
          },
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 28),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            dayTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          ),
          appointmentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 9,
            endHour: 22.5,
            timeFormat: "HH:mm",
            timeInterval: const Duration(minutes: 30),
            timeIntervalWidth: 120,
            timeIntervalHeight: 60,
            timeTextStyle: TextStyle(fontSize: 16),
          ),
          resourceViewSettings: ResourceViewSettings(
            visibleResourceCount: 5,
            showAvatar: false,
            displayNameTextStyle: TextStyle(fontSize: 20),
          ),
          initialDisplayDate: controller.selectedDay,
          showDatePickerButton: true,
          showCurrentTimeIndicator: false,
          // allowViewNavigation: true,
          allowedViews: [CalendarView.week, CalendarView.timelineDay],
        );
      },
    );
  }

  Future _showReserved(CalendarTapDetails details) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                _showCancelByUser(details);
              },
              child: Text("취소 (수강생)", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showCancelByAdmin(details);
              },
              child: Text("취소 (관리자)", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showExtendByUser(details);
              },
              child: Text("연장 (수강생)", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showExtendByAdmin(details);
              },
              child: Text("연장 (관리자)", style: TextStyle(fontSize: 24)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }

  Future _showCancelByUser(CalendarTapDetails details) {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "취소 (수강생)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Text(
            "수강생의 권한으로 취소하시겠습니까?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await client.cancelReservation(details.appointments![0].id);
                } catch (e) {
                  showErrorMessage(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "확인",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _showCancelByAdmin(CalendarTapDetails details) {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "취소 (관리자)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Text(
            "관리자의 권한으로 취소하시겠습니까?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await client
                      .cancelReservationByAdmin(details.appointments![0].id);
                } catch (e) {
                  showErrorMessage(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "확인",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _showExtendByUser(CalendarTapDetails details) {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "연장 (수강생)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          content: Text(
            "수강생의 권한으로 연장하시겠습니까?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await client.extendReservation(details.appointments![0].id);
                } catch (e) {
                  showErrorMessage(context, e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(96, 128, 104, 100),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Text(
                "확인",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _showExtendByAdmin(CalendarTapDetails details) {
    bool count = false;

    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "연장 (관리자)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "관리자의 권한으로 연장하시겠습니까?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 240,
                          child: Text(
                            "카운트 포함",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: count,
                          onChanged: (value) {
                            setState(() {
                              count = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  ),
                  child: Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await client.extendReservationByAdmin(
                        id: details.appointments![0].id,
                        count: count ? 1 : 0,
                      );
                    } catch (e) {
                      showErrorMessage(context, e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  ),
                  child: Text(
                    "확인",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future _showEmpty(CalendarTapDetails details) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                // _showReserveRegular(details);
              },
              child: Text("정규 등록", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // _showMakeUp(details);
              },
              child: Text("보강 예약", style: TextStyle(fontSize: 24)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // _showFreeCourse(details);
              },
              child: Text("무료 보강 등록", style: TextStyle(fontSize: 24)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}
