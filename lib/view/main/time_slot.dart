import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot extends StatefulWidget {
  const TimeSlot({Key? key}) : super(key: key);

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  Client client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  TextEditingController teacherRegular = TextEditingController();
  BranchController branchRegular = Get.put(BranchController(), tag: "Regular");
  DateTimeController endRegular = Get.put(DateTimeController(), tag: "Regular");
  TextEditingController userRegular = TextEditingController();

  TextEditingController teacherUser = TextEditingController();
  BranchController branchUser = Get.put(BranchController(), tag: "User");
  TextEditingController userUser = TextEditingController();

  TextEditingController teacherAdmin = TextEditingController();
  BranchController branchAdmin = Get.put(BranchController(), tag: "Admin");
  TextEditingController userAdmin = TextEditingController();

  TextEditingController teacherFree = TextEditingController();
  BranchController branchFree = Get.put(BranchController(), tag: "Free");
  DateTimeController endFree = Get.put(DateTimeController(), tag: "Free");
  TextEditingController userFree = TextEditingController();

  SearchController search = Get.find<SearchController>(tag: "Main");
  bool hasBeenShown = false;

  CalendarController calendarController = Get.find<CalendarController>();

  @override
  void dispose() {
    teacherRegular.dispose();
    userRegular.dispose();
    teacherUser.dispose();
    userUser.dispose();
    teacherAdmin.dispose();
    userAdmin.dispose();
    teacherFree.dispose();
    userFree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: calendarController,
          onTap: (details) async {
            if (!search.isSearched && !hasBeenShown) {
              await showError("필터를 사용하여 예약을 검색할 수 있습니다");
              hasBeenShown = true;
            }

            if (details.targetElement == CalendarElement.viewHeader) {
              if (calendarController.view == CalendarView.week) {
                calendarController.view = CalendarView.timelineDay;
              } else {
                calendarController.view = CalendarView.week;
              }

              calendarController.displayDate = details.date!;
              controller.updateDisplayDate(calendarController.displayDate!);
            } else if (details.targetElement == CalendarElement.calendarCell) {
              _showEmpty(details);
            } else if (details.targetElement == CalendarElement.appointment) {
              _showReserved(details);
            }
          },
          onViewChanged: (details) async {
            if (!isSameWeek(
                calendarController.displayDate!, controller.displayDate)) {
              controller.updateDisplayDate(calendarController.displayDate!);

              try {
                if (search.isSearched) {
                  await getReservationData(
                    displayDate: controller.displayDate,
                    branchName: search.text1!,
                    userID: search.text2,
                    teacherID: search.text3,
                  );
                }
              } catch (e) {
                showError(e.toString());
              }
            }
          },
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 28.r),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: TextStyle(color: Colors.white, fontSize: 20.r),
            dayTextStyle: TextStyle(color: Colors.white, fontSize: 16.r),
          ),
          appointmentTextStyle: TextStyle(color: Colors.white, fontSize: 16.r),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 9,
            endHour: 22.5,
            timeFormat: "HH:mm",
            timeInterval: const Duration(minutes: 30),
            timeIntervalWidth: 120.r,
            timeIntervalHeight: 60.r,
            timeTextStyle: TextStyle(fontSize: 16.r),
          ),
          resourceViewSettings: ResourceViewSettings(
            visibleResourceCount: 5,
            showAvatar: false,
            displayNameTextStyle: TextStyle(fontSize: 20.r),
          ),
          initialDisplayDate: controller.displayDate,
          showCurrentTimeIndicator: false,
          showNavigationArrow: true,
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
              child: Text("취소 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showCancelByAdmin(details);
              },
              child: Text("취소 (관리자)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showExtendByUser(details);
              },
              child: Text("연장 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showExtendByAdmin(details);
              },
              child: Text("연장 (관리자)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _showDeleteLaterCourse(details);
              },
              child: Text("정규 종료", style: TextStyle(fontSize: 24.r)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }

  Future _showCancelByUser(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "취소 (수강생)",
      contents: [
        Text(
          "수강생의 권한으로 취소하시겠습니까?",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: () async {
        try {
          await client.cancelReservation(details.appointments![0].id);

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
    );
  }

  Future _showCancelByAdmin(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "취소 (관리자)",
      contents: [
        Text(
          "관리자의 권한으로 취소하시겠습니까?",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: () async {
        try {
          await client.cancelReservationByAdmin(details.appointments![0].id);

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
    );
  }

  Future _showExtendByUser(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "연장 (수강생)",
      contents: [
        Text(
          "수강생의 권한으로 연장하시겠습니까?",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: () async {
        try {
          await client.extendReservation(details.appointments![0].id);

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
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
                style: TextStyle(color: Colors.white, fontSize: 28.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "관리자의 권한으로 연장하시겠습니까?",
                    style: TextStyle(color: Colors.white, fontSize: 20.r),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 240.r,
                          child: Text(
                            "카운트 포함",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.r,
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
                    padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                  ),
                  child: Text(
                    "취소",
                    style: TextStyle(color: Colors.white, fontSize: 20.r),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await client.extendReservationByAdmin(
                        id: details.appointments![0].id,
                        count: count ? 1 : 0,
                      );

                      if (search.isSearched) {
                        await getReservationData(
                          displayDate: _controller.displayDate,
                          branchName: search.text1!,
                          userID: search.text2,
                          teacherID: search.text3,
                        );
                      }

                      Get.back();
                    } catch (e) {
                      showError(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                    padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                  ),
                  child: Text("확인", style: TextStyle(fontSize: 20.r)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future _showDeleteLaterCourse(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "정규 종료",
      contents: [
        Text(
          "종료일: " +
              DateFormat("yy/MM/dd HH:mm")
                  .format(details.appointments![0].endDate),
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: () async {
        try {
          await client.updateEndDateAndDeleteLaterCourse(
            details.appointments![0].regularID,
            endDate: details.appointments![0].endDate,
          );

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
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
              onPressed: () => _showReserveRegular(details),
              child: Text("정규 등록", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showMakeUpByUser(details),
              child: Text("보강 예약 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showMakeUpByAdmin(details),
              child: Text("보강 예약 (관리자)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showFreeCourse(details),
              child: Text("무료 보강 등록", style: TextStyle(fontSize: 24.r)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }

  Future _showReserveRegular(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "정규 등록",
      contents: [
        Text(
          DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ ",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        textInput("강사", teacherRegular, "강사명을 입력하세요!"),
        branchDropdown("Regular", "지점을 선택하세요!"),
        pickTime(context, "종료시각", "Regular", true),
        textInput("수강생", userRegular, "이름을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          await client.reserveRegularReservation(
            teacherID: teacherRegular.text,
            branchName: branchRegular.branchName!,
            startDate: details.date!,
            endDate: DateUtils.dateOnly(details.date!).add(Duration(
              hours: endRegular.time!.hour,
              minutes: endRegular.time!.minute,
            )),
            userID: userRegular.text,
          );

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }

  Future _showMakeUpByUser(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "보강 예약 (수강생)",
      contents: [
        Text(
          DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ ",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        textInput("강사", teacherUser, "강사명을 입력하세요!"),
        branchDropdown("User", "지점을 선택하세요!"),
        textInput("수강생", userUser, "이름을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          RegularSchedule regular =
              (await client.getRegularSchedulesByAdmin(userUser.text))[0];

          await client.makeUpReservation(
            teacherID: teacherUser.text,
            branchName: branchUser.branchName!,
            startDate: details.date!,
            endDate: details.date!.add(regular.endTime - regular.startTime),
            userID: userUser.text,
          );

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }

  Future _showMakeUpByAdmin(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "보강 예약 (관리자)",
      contents: [
        Text(
          DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ ",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        textInput("강사", teacherAdmin, "강사명을 입력하세요!"),
        branchDropdown("Admin", "지점을 선택하세요!"),
        textInput("수강생", userAdmin, "이름을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          RegularSchedule regular =
              (await client.getRegularSchedulesByAdmin(userAdmin.text))[0];

          await client.makeUpReservationByAdmin(
            teacherID: teacherAdmin.text,
            branchName: branchAdmin.branchName!,
            startDate: details.date!,
            endDate: details.date!.add(regular.endTime - regular.startTime),
            userID: userAdmin.text,
          );

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }

  Future _showFreeCourse(CalendarTapDetails details) {
    return showMyDialog(
      context: context,
      title: "무료 보강 등록",
      contents: [
        Text(
          DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ ",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        textInput("강사", teacherFree, "강사명을 입력하세요!"),
        branchDropdown("Free", "지점을 선택하세요!"),
        pickTime(context, "종료시각", "Free", true),
        textInput("수강생", userFree, "이름을 입력하세요!"),
      ],
      onPressed: () async {
        try {
          await client.reserveFreeCourse(
            teacherID: teacherFree.text,
            branchName: branchFree.branchName!,
            startDate: details.date!,
            endDate: DateUtils.dateOnly(details.date!).add(Duration(
              hours: endFree.time!.hour,
              minutes: endFree.time!.minute,
            )),
            userID: userFree.text,
          );

          if (search.isSearched) {
            await getReservationData(
              displayDate: _controller.displayDate,
              branchName: search.text1!,
              userID: search.text2,
              teacherID: search.text3,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }
}
