import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/reservation.dart';
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
          timeZone: "Korea Standard Time",
          dataSource: _data.reservationDataSource,
          specialRegions: _data.timeRegions,
          controller: _calendar,
          onTap: (details) async {
            if (!search.isSearched && !search.hasBeenShown) {
              await showMySnackbar(
                title: "팁",
                message: "필터를 사용하여 예약을 검색할 수 있습니다.",
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
              _data.updateDisplayDate(_calendar.displayDate!);
            } else if (details.targetElement == CalendarElement.calendarCell) {
              if (_calendar.view == CalendarView.timelineDay) {
                _showEmpty(details);
              }
            } else if (details.targetElement == CalendarElement.appointment) {
              _showReserved(details);
            }
          },
          onViewChanged: (details) {
            if (!isSameWeek(_calendar.displayDate!, _data.displayDate)) {
              _data.updateDisplayDate(_calendar.displayDate!);

              showLoading(() async {
                try {
                  await _getSearchedReservationsData();
                } catch (e) {
                  showError(e);
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
          initialDisplayDate: _data.displayDate,
          showCurrentTimeIndicator: false,
          showNavigationArrow: true,
          allowedViews: [CalendarView.week, CalendarView.timelineDay],
        );
      },
    );
  }

  Future _showReserved(CalendarTapDetails details) {
    var info = details.appointments![0];

    return showMyModal(
      context: context,
      message: info.userID + " | " + formatDateTime(info.startDate),
      children: ["취소 (관리자)", "연장 (관리자)", "예약 삭제", "정기 종료", "정기 삭제"],
      isDestructiveAction: [false, false, true, true, true],
      onPressed: [
        () => _showCancelByAdmin(details),
        () => _showExtendByAdmin(details),
        () => _showDeleteReservation(details),
        () => _showDeleteLaterCourse(details),
        () => _showDeleteRegular(details),
      ],
    );
  }

  Future _showCancelByAdmin(CalendarTapDetails details) {
    var deductCredit = false;

    return showMyDialog(
      title: "취소 (관리자)",
      contents: [
        Text("관리자의 권한으로 취소하시겠습니까?"),
        Row(
          children: [
            label("크레딧 차감", true),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: deductCredit,
                  onChanged: (value) {
                    setState(() {
                      deductCredit = value!;
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
          await _client.cancelReservationByAdmin(
            details.appointments![0].id,
            deductCredit: deductCredit,
          );

          await _getSearchedReservationsData();
          Get.until(ModalRoute.withName("/main"));
          await showMySnackbar(
            message:
                "관리자의 권한으로 크레딧을 ${deductCredit ? "차감" : "미차감"}하여 예약을 취소했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
    );
  }

  Future _showExtendByAdmin(CalendarTapDetails details) {
    var deductCredit = false;

    return showMyDialog(
      title: "연장 (관리자)",
      contents: [
        Text("관리자의 권한으로 연장하시겠습니까?"),
        Row(
          children: [
            label("크레딧 차감", true),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: deductCredit,
                  onChanged: (value) {
                    setState(() {
                      deductCredit = value!;
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
            deductCredit: deductCredit,
          );

          await _getSearchedReservationsData();
          Get.until(ModalRoute.withName("/main"));
          await showMySnackbar(
            message:
                "관리자의 권한으로 크레딧을 ${deductCredit ? "차감" : "미차감"}하여 예약을 연장했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
    );
  }

  Future _showDeleteReservation(CalendarTapDetails details) {
    return showMyDialog(
      title: "예약 삭제",
      contents: [
        Text("예약을 삭제하시겠습니까?\n취소 내역에 기록되지 않습니다."),
        Text(
          "\n*되돌릴 수 없습니다.*" +
              "\n\n*취소와는 다른 기능입니다.*" +
              "\n\n*강제로 예약 데이터를 삭제합니다.\n예상치 못한 오류가 발생할 수 있습니다.*" +
              "\n\n*잘못 예약했을 경우 즉시 철회하는\n용도로만 사용하는 것을 권장합니다.*",
          style: TextStyle(color: Colors.red),
        ),
      ],
      onPressed: () {
        showMyDialog(
          contents: [
            Text(
              "정말로 삭제하시겠습니까?",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.deleteReservation(details.appointments![0].id);

              await _getSearchedReservationsData();
              Get.until(ModalRoute.withName("/main"));
              await showMySnackbar(message: "예약을 삭제했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
      isScrollable: true,
    );
  }

  Future _showDeleteLaterCourse(CalendarTapDetails details) {
    final appointments = details.appointments! as List<Reservation>;
    final reservation = appointments.first;

    return showMyDialog(
      title: "정기 종료",
      contents: [
        Text("종료일: " +
            formatDateTime(reservation.startDate) +
            "\n\n정기 스케줄의 종료일을 갱신하시겠습니까?" +
            "\n선택한 수업을 포함하여 종료일 이후의" +
            "\n해당 정기 수업들을 모두 삭제합니다." +
            "\n\n*시작하지 않은 정기 스케줄은\n'정기 삭제' 기능을 이용하기 바랍니다.*"),
      ],
      onPressed: () {
        showMyDialog(
          contents: [
            Text(
              "정말로 정기 스케줄을 종료하시겠습니까?",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              final regularID = reservation.regularID;
              if (regularID == null) {
                showError("정기 스케줄을 따르는 예약인 경우에만 정기 종료 할 수 있습니다.");
                return;
              }

              await _client.updateEndDateAndDeleteLaterCourse(
                regularID,
                endDate: reservation.startDate,
              );

              await _getSearchedReservationsData();
              Get.until(ModalRoute.withName("/main"));
              await showMySnackbar(message: "정기 종료에 성공했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
    );
  }

  Future _showDeleteRegular(CalendarTapDetails details) {
    final appointments = details.appointments! as List<Reservation>;
    final reservation = appointments.first;

    return showMyDialog(
      title: "정기 삭제",
      contents: [
        Text("아직 시작하지 않은 정기 스케줄을 삭제하고" +
            "\n해당하는 정기 수업들을 모두 삭제합니다." +
            "\n\n*이미 시작한 정기 스케줄은\n'정기 종료' 기능을 이용하기 바랍니다.*"),
      ],
      onPressed: () {
        showMyDialog(
          contents: [
            Text(
              "정말로 정기 스케줄을 삭제하시겠습니까?",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              final regularID = reservation.regularID;
              if (regularID == null) {
                showError("정기 스케줄을 따르는 예약인 경우에만 정기 삭제 할 수 있습니다.");
                return;
              }

              await _client.deleteRegularSchedule(regularID);

              await _getSearchedReservationsData();
              Get.until(ModalRoute.withName("/main"));
              await showMySnackbar(message: "정기 삭제에 성공했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
    );
  }

  Future _showEmpty(CalendarTapDetails details) {
    return showMyModal(
      context: context,
      message:
          details.resource!.displayName + " | " + formatDateTime(details.date!),
      children: ["정기 등록", "보강 예약 (관리자)", "무료 보강 등록"],
      isDestructiveAction: [false, false, false],
      onPressed: [
        () => _showReserveRegular(details),
        () => _showMakeUpByAdmin(details),
        () => _showFreeCourse(details),
      ],
    );
  }

  Future _showReserveRegular(CalendarTapDetails details) {
    regular.reset();
    regular.edit1.text = details.resource!.displayName;
    regular.branchName = search.branchName;
    regular.edit2.text = search.edit1.text;

    return showMyDialog(
      title: "정기 등록",
      contents: [
        Text(
            "정기 스케줄을 생성하고 수업을 예약합니다.\n" + formatDateTime(details.date!) + " ~"),
        myTextInput("강사", regular.edit1, isMandatory: true),
        branchDropdown("/regular", true),
        durationDropdown("/regular", true),
        myTextInput("수강생", regular.edit2, isMandatory: true),
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
          Get.until(ModalRoute.withName("/main"));
          await showMySnackbar(
            message: "정기 스케줄을 생성하고 수업을 예약했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future _showMakeUpByAdmin(CalendarTapDetails details) {
    admin.reset();
    admin.edit1.text = details.resource!.displayName;
    admin.branchName = search.branchName;
    admin.edit2.text = search.edit1.text;

    return showMyDialog(
      title: "보강 예약 (관리자)",
      contents: [
        Text("관리자의 권한으로 보강을 예약합니다.\n" + formatDateTime(details.date!) + " ~"),
        myTextInput("강사", admin.edit1, isMandatory: true),
        branchDropdown("/admin", true),
        durationDropdown("/admin", true),
        myTextInput("수강생", admin.edit2, isMandatory: true),
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
          Get.until(ModalRoute.withName("/main"));
          await showMySnackbar(
            message: "관리자의 권한으로 보강을 예약했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future _showFreeCourse(CalendarTapDetails details) {
    free.reset();
    free.edit1.text = details.resource!.displayName;
    free.branchName = search.branchName;
    free.edit2.text = search.edit1.text;

    return showMyDialog(
      title: "무료 보강 등록",
      contents: [
        Text(formatDateTime(details.date!) + " ~"),
        myTextInput("강사", free.edit1, isMandatory: true),
        branchDropdown("/free", true),
        durationDropdown("/free", true),
        myTextInput("수강생", free.edit2, isMandatory: true),
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
          Get.until(ModalRoute.withName("/main"));
          await showMySnackbar(message: "무료 보강을 예약했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }

  Future<void> _getSearchedReservationsData() async {
    if (search.isSearched) {
      await _data.getReservationData(
        branchName: search.branchName!,
        userID: textEdit(search.edit1),
        teacherID: textEdit(search.edit2),
      );
    } else {
      await showMySnackbar(
        title: "알림",
        message: "검색값이 없습니다.",
      );
    }
  }
}
