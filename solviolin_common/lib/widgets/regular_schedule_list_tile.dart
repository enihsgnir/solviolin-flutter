import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/regular_schedule.dart';
import 'package:solviolin_common/providers/client_state/regular_schedule_state_provider.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/reservation_list_provider.dart';
import 'package:solviolin_common/providers/user_list_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/date_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/time_select_field.dart';

class RegularScheduleListTile extends ConsumerWidget {
  final RegularSchedule regularSchedule;
  final bool isForAdmin;
  final bool shouldPopAfterAction;

  const RegularScheduleListTile(
    this.regularSchedule, {
    super.key,
    this.isForAdmin = false,
    this.shouldPopAfterAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchName = regularSchedule.branchName;
    final teacherID = regularSchedule.teacherID;
    final dow = regularSchedule.dow.inline;
    final start = regularSchedule.startTime.format(durationTime);
    final end = regularSchedule.endTime.format(durationTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("강사:"),
              Text("$branchName $teacherID"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("수업 시간:"),
              Text("$dow $start ~ $end"),
            ],
          ),
          if (isForAdmin) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => showDelete(context, ref),
                  child: const Text("정기삭제"),
                ),
                TextButton(
                  onPressed: () => showTerminate(context, ref),
                  child: const Text("정기종료"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> showDelete(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("아직 시작하지 않은 정기 스케줄을 삭제하고 해당하는 정기 수업들을 모두 삭제합니다"),
        SizedBox(height: 16),
        Text("정기수업 시작 전인 경우 이번 학기의 예약 목록 중 첫 번째 정기 예약에 해당하는 정기 스케줄을 삭제합니다"),
        SizedBox(height: 16),
        Text("이미 시작한 정기 스케줄은 '정기 종료' 기능을 이용하기 바랍니다"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    final isConfirmedAgain = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text(
          "정말로 정기 스케줄을 삭제하시겠습니까?",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (!isConfirmedAgain) return;

    if (!context.mounted) return;
    await ref
        .read(regularScheduleStateProvider.notifier)
        .delete(regularSchedule.id)
        .withLoadingOverlay(context);

    // refresh `UserDetailPage`
    ref.invalidate(userListProvider);

    // refresh `ReservationTimeSlot`
    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    if (shouldPopAfterAction) context.pop();
  }

  Future<void> showTerminate(BuildContext context, WidgetRef ref) async {
    DateTime endDate = DateTime.now();
    Duration endTime = Duration.zero;

    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        const Text("정기 스케줄의 종료일을 갱신하고 종료일 이후의 해당 정기 수업들을 모두 삭제합니다"),
        const SizedBox(height: 16),
        const Text("시작하지 않은 정기 스케줄은 '정기 삭제' 기능을 이용하기 바랍니다"),
        const FormTitle("종료일", isRequired: true),
        DateSelectField(onChanged: (value) => endDate = value),
        const SizedBox(height: 8),
        TimeSelectField(onChanged: (value) => endTime = value),
      ],
    );

    if (!isConfirmed) return;

    final endDateTime = endDate.add(endTime);

    if (!context.mounted) return;
    final isConfirmedAgain = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        Text("종료일: ${endDateTime.format(dateTime)}"),
        const SizedBox(height: 8),
        const Text(
          "정말로 정기 스케줄을 종료하시겠습니까?",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (!isConfirmedAgain) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .updateEndDateAndDeleteLaterCourse(
          regularSchedule.id,
          endDate: endDateTime,
        )
        .withLoadingOverlay(context);

    // refresh `UserDetailPage`
    ref.invalidate(userListProvider);

    // refresh `ReservationTimeSlot`
    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    if (shouldPopAfterAction) context.pop();
  }
}
