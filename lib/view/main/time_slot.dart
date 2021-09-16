import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot extends StatefulWidget {
  const TimeSlot({Key? key}) : super(key: key);

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var _calendar = Get.find<CalendarController>(tag: "/admin");

  var search = Get.find<CacheController>(tag: "/search/main");
  var regular = Get.put(CacheController(), tag: "/regular");
  var admin = Get.put(CacheController(), tag: "/admin");
  var free = Get.put(CacheController(), tag: "/free");

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: _calendar,
          onTap: (details) async {
            if (!search.isSearched && !search.hasBeenShown) {
              // await showError("필터를 사용하여 예약을 검색할 수 있습니다");
              await showMySnackbar(
                title: "팁",
                message: "필터를 사용하여 예약을 검색할 수 있습니다",
              );
              search.hasBeenShown = true;
            }

            if (details.targetElement == CalendarElement.viewHeader) {
              if (_calendar.view == CalendarView.week) {
                _calendar.view = CalendarView.timelineDay;
              } else {
                _calendar.view = CalendarView.week;
              }

              _calendar.displayDate = details.date!;
              controller.updateDisplayDate(_calendar.displayDate!);
            } else if (details.targetElement == CalendarElement.calendarCell) {
              if (_calendar.view == CalendarView.timelineDay) {
                _showEmpty(details);
              }
            } else if (details.targetElement == CalendarElement.appointment) {
              _showReserved(details);
            }
          },
          onViewChanged: (details) {
            if (!isSameWeek(_calendar.displayDate!, controller.displayDate)) {
              controller.updateDisplayDate(_calendar.displayDate!);

              showLoading(() async {
                try {
                  await _getSearchedReservationsData();
                } catch (e) {
                  showError(e.toString());
                }
              });
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
              onPressed: () => _showCancelByUser(details),
              child: Text("취소 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showCancelByAdmin(details),
              child: Text("취소 (관리자)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showExtendByUser(details),
              child: Text("연장 (수강생)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showExtendByAdmin(details),
              child: Text("연장 (관리자)", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showDeleteLaterCourse(details),
              child: Text("정규 종료", style: TextStyle(fontSize: 24.r)),
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

  Future _showCancelByUser(CalendarTapDetails details) {
    return showMyDialog(
      title: "취소 (수강생)",
      contents: [
        Text("수강생의 권한으로 취소하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.cancelReservation(details.appointments![0].id);

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
    );
  }

  Future _showCancelByAdmin(CalendarTapDetails details) {
    return showMyDialog(
      title: "취소 (관리자)",
      contents: [
        Text("관리자의 권한으로 취소하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.cancelReservationByAdmin(details.appointments![0].id);

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
    );
  }

  Future _showExtendByUser(CalendarTapDetails details) {
    return showMyDialog(
      title: "연장 (수강생)",
      contents: [
        Text("수강생의 권한으로 연장하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.extendReservation(details.appointments![0].id);

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
    );
  }

  Future _showExtendByAdmin(CalendarTapDetails details) {
    var count = false;

    return showMyDialog(
      title: "연장 (관리자)",
      contents: [
        Text("관리자의 권한으로 연장하시겠습니까?"),
        Row(
          children: [
            Container(
              width: 120.r,
              child: label("카운트 포함", true),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: count,
                  onChanged: (value) {
                    setState(() {
                      count = value!;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.extendReservationByAdmin(
            details.appointments![0].id,
            count: count ? 1 : 0,
          );

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
    );
  }

  Future _showDeleteLaterCourse(CalendarTapDetails details) {
    return showMyDialog(
      title: "정규 종료",
      contents: [
        Text("종료일: " +
            DateFormat("yy/MM/dd HH:mm")
                .format(details.appointments![0].endDate)),
        Text("정규 스케줄을 종료하고"),
        Text("이후 수업을 삭제하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.updateEndDateAndDeleteLaterCourse(
            details.appointments![0].regularID,
            endDate: details.appointments![0].endDate,
          );

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
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
    regular.reset();

    if (search.isSearched) {
      regular.edit1.text = search.edit2.text;
      regular.branchName = search.branchName;
      regular.edit2.text = search.edit1.text;
    }

    return showMyDialog(
      title: "정규 등록",
      contents: [
        Text(DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ "),
        myTextInput("강사", regular.edit1, "강사명을 입력하세요!"),
        branchDropdown("/regular", "지점을 선택하세요!"),
        durationDropdown("/regular", "수업시간을 선택하세요!"),
        myTextInput("수강생", regular.edit2, "이름을 입력하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.reserveRegularReservation(
            teacherID: textEdit(regular.edit1)!,
            branchName: regular.branchName!,
            startDate: details.date!,
            endDate: details.date!.add(regular.duration!),
            userID: textEdit(regular.edit2)!,
          );

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future _showMakeUpByAdmin(CalendarTapDetails details) {
    admin.reset();

    if (search.isSearched) {
      admin.edit1.text = search.edit2.text;
      admin.branchName = search.branchName;
      admin.edit2.text = search.edit1.text;
    }

    return showMyDialog(
      title: "보강 예약 (관리자)",
      contents: [
        Text(DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ "),
        myTextInput("강사", admin.edit1, "강사명을 입력하세요!"),
        branchDropdown("/admin", "지점을 선택하세요!"),
        durationDropdown("/admin", "수업시간을 선택하세요!"),
        myTextInput("수강생", admin.edit2, "이름을 입력하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.makeUpReservationByAdmin(
            teacherID: textEdit(admin.edit1)!,
            branchName: admin.branchName!,
            startDate: details.date!,
            endDate: details.date!.add(admin.duration!),
            userID: textEdit(admin.edit2)!,
          );

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future _showFreeCourse(CalendarTapDetails details) {
    free.reset();

    if (search.isSearched) {
      free.edit1.text = search.edit2.text;
      free.branchName = search.branchName;
      free.edit2.text = search.edit1.text;
    }

    return showMyDialog(
      title: "무료 보강 등록",
      contents: [
        Text(DateFormat("yy/MM/dd HH:mm").format(details.date!) + " ~ "),
        myTextInput("강사", free.edit1, "강사명을 입력하세요!"),
        branchDropdown("/free", "지점을 선택하세요!"),
        durationDropdown("/free", "수업시간을 선택하세요!"),
        myTextInput("수강생", free.edit2, "이름을 입력하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.reserveFreeCourse(
            teacherID: textEdit(free.edit1)!,
            branchName: free.branchName!,
            startDate: details.date!,
            endDate: details.date!.add(free.duration!),
            userID: textEdit(free.edit2)!,
          );

          await _getSearchedReservationsData();
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future<void> _getSearchedReservationsData() async {
    if (search.isSearched) {
      await getReservationData(
        displayDate: _data.displayDate,
        branchName: search.branchName!,
        userID: textEdit(search.edit1),
        teacherID: textEdit(search.edit2),
      );
    }
  }
}
