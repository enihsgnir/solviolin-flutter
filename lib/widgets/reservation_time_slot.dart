import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/extensions/calendar_resource_extension.dart';
import 'package:solviolin/models/reservation.dart';
import 'package:solviolin/providers/display_date_provider.dart';
import 'package:solviolin/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin/providers/profile_provider.dart';
import 'package:solviolin/providers/reservation_data_source_provider.dart';
import 'package:solviolin/providers/reservation_time_regions_provider.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/date_select_field.dart';
import 'package:solviolin/widgets/reservation_info_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationTimeSlot extends ConsumerStatefulWidget {
  final bool isForTeacher;

  const ReservationTimeSlot({
    super.key,
    this.isForTeacher = false,
  });

  @override
  _ReservationTimeSlotState createState() => _ReservationTimeSlotState();
}

class _ReservationTimeSlotState extends ConsumerState<ReservationTimeSlot> {
  final controller = CalendarController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final profile = await ref.read(profileProvider.future);
      ref
          .read(reservationSearchFormProvider.notifier)
          .search(branchName: profile.branchName);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = ref.watch(displayDateProvider);
    final dataSource = ref.watch(dataSourceProvider).valueOrNull;
    final timeRegions = ref.watch(timeRegionsProvider).valueOrNull;

    return SfCalendar(
      controller: controller,
      view: CalendarView.week,
      initialDisplayDate: displayDate,
      dataSource: dataSource,
      specialRegions: timeRegions,
      onTap: (details) async {
        switch (details.targetElement) {
          case CalendarElement.header:
            await showChangeDate();

          case CalendarElement.viewHeader:
            if (controller.view == CalendarView.week) {
              controller.view = CalendarView.timelineDay;
            } else if (controller.view == CalendarView.timelineDay) {
              controller.view = CalendarView.week;
            }

            final date = details.date;
            if (date != null) {
              controller.displayDate = date;
              ref.read(displayDateProvider.notifier).setValue(date);
            }

          case CalendarElement.calendarCell:
            if (controller.view == CalendarView.timelineDay &&
                details.resource.isNotOthers) {
              final teacherID = details.resource!.displayName;
              final startDate = details.date!;

              if (!widget.isForTeacher) {
                context.push(
                  "/admin/reservation/create",
                  extra: {
                    "teacherID": teacherID,
                    "startDate": startDate,
                  },
                );
              }
            }

          case CalendarElement.appointment:
            final reservation = details.appointments!.cast<Reservation>().first;

            if (widget.isForTeacher) {
              await showReservationInfo(reservation);
            } else {
              context.push("/admin/reservation/${reservation.id}");
            }

          default:
            break;
        }
      },
      onViewChanged: (details) {
        final date = controller.displayDate;
        if (date != null) {
          // use post frame callback to avoid error generated when changing date
          // by the date change dialog
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.read(displayDateProvider.notifier).setValue(date);
          });
        }
      },
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: Colors.transparent,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 9,
        endHour: 22.5,
        timeFormat: "HH:mm",
        timeInterval: Duration(minutes: 30),
        timeIntervalWidth: 60,
        timeIntervalHeight: 60,
        timeTextStyle: TextStyle(fontSize: 14),
      ),
      resourceViewSettings: ResourceViewSettings(
        visibleResourceCount: widget.isForTeacher ? 2 : 8,
        showAvatar: false,
        displayNameTextStyle: const TextStyle(fontSize: 16),
      ),
      appointmentTextStyle: const TextStyle(fontSize: 12),
      showNavigationArrow: true,
      showTodayButton: true,
      allowedViews: const [CalendarView.week, CalendarView.timelineDay],
    );
  }

  Future<void> showChangeDate() async {
    DateTime targetDate = ref.read(displayDateProvider);

    final isConfirmed = await showConfirmationDialog(
      context,
      content: [
        const Text("날짜 이동", style: titleLarge),
        const SizedBox(height: 12),
        DateSelectField(
          initialValue: targetDate,
          onChanged: (value) => targetDate = value,
        ),
      ],
    );

    if (!isConfirmed) return;

    controller.displayDate = targetDate;
  }

  Future<void> showReservationInfo(Reservation reservation) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ReservationInfoCard(reservation),
          ),
        );
      },
    );
  }
}
