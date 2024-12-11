import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/reservation.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin/providers/reservation_list_provider.dart';
import 'package:solviolin/providers/term_reservations_provider.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/credit_deduction_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class ReservationListTile extends ConsumerWidget {
  final Reservation reservation;
  final bool showActions;
  final bool isForAdmin;
  final bool shouldPopAfterAction;

  const ReservationListTile(
    this.reservation, {
    super.key,
    this.showActions = true,
    this.isForAdmin = false,
    this.shouldPopAfterAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = reservation.bookingStatus;

    final now = DateTime.now();
    final isValid = reservation.startDate.isAfter(now);
    final isValidToCancel = isValid && !status.isCanceled;
    final isValidToExtend = isValid && !status.isExtended && !status.isCanceled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${status.label} 수업입니다",
            style: const TextStyle(color: gray600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("강사:"),
              Text("${reservation.branchName} ${reservation.teacherID}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("날짜:"),
              Text(
                reservation.range.format(dateTimeRange),
                style: TextStyle(color: status.isCanceled ? gray600 : null),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isValidToCancel
                      ? () async {
                          if (isForAdmin) {
                            await showCancelByAdmin(context, ref);
                          } else {
                            await showCancel(context, ref);
                          }
                        }
                      : null,
                  child: const Text("수업 취소"),
                ),
                TextButton(
                  onPressed: isValidToExtend
                      ? () async {
                          if (isForAdmin) {
                            await showExtendByAdmin(context, ref);
                          } else {
                            await showExtend(context, ref);
                          }
                        }
                      : null,
                  child: const Text("수업 연장"),
                ),
                if (isForAdmin)
                  TextButton(
                    onPressed: () => showDelete(context, ref),
                    child: const Text("수업 삭제"),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> showCancel(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        Text("${reservation.branchName} ${reservation.teacherID}"),
        const SizedBox(height: 8),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("수업을 취소 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .cancel(reservation.id)
        .withLoadingOverlay(context);

    ref.invalidate(termReservationsProvider);
  }

  Future<void> showCancelByAdmin(BuildContext context, WidgetRef ref) async {
    bool deductCredit = false;

    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        const FormTitle("크레딧 차감", isRequired: true),
        CreditDeductionSelectField(
          onChanged: (value) => deductCredit = value,
        ),
        const SizedBox(height: 24),
        Text("${reservation.branchName} ${reservation.teacherID}"),
        const SizedBox(height: 8),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("관리자의 권한으로 수업을 취소 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .cancelByAdmin(reservation.id, deductCredit: deductCredit)
        .withLoadingOverlay(context);

    // refresh `UserDetailReservationList`
    ref.invalidate(termReservationsProvider);

    // refresh `ReservationTimeSlot`
    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    if (shouldPopAfterAction) context.pop();
  }

  Future<void> showExtend(BuildContext context, WidgetRef ref) async {
    const extra = Duration(minutes: 15);
    final newRange = (reservation.startDate, reservation.endDate.add(extra));

    final isConfirmed = await showConfirmationDialog(
      context,
      content: [
        Text("${reservation.branchName} ${reservation.teacherID}"),
        const SizedBox(height: 8),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("수업을 15분 연장 하시겠습니까?"),
        const SizedBox(height: 24),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        Text("\u2192 ${newRange.format(dateTimeRange)}"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .extend(reservation.id)
        .withLoadingOverlay(context);

    ref.invalidate(termReservationsProvider);
  }

  Future<void> showExtendByAdmin(BuildContext context, WidgetRef ref) async {
    bool deductCredit = false;

    const extra = Duration(minutes: 15);
    final newRange = (reservation.startDate, reservation.endDate.add(extra));

    final isConfirmed = await showConfirmationDialog(
      context,
      content: [
        const FormTitle("크레딧 차감", isRequired: true),
        CreditDeductionSelectField(
          onChanged: (value) => deductCredit = value,
        ),
        const SizedBox(height: 24),
        Text("${reservation.branchName} ${reservation.teacherID}"),
        const SizedBox(height: 8),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("관리자의 권한으로 수업을 15분 연장 하시겠습니까?"),
        const SizedBox(height: 24),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        Text("\u2192 ${newRange.format(dateTimeRange)}"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .extendByAdmin(reservation.id, deductCredit: deductCredit)
        .withLoadingOverlay(context);

    // refresh `UserDetailReservationList`
    ref.invalidate(termReservationsProvider);

    // refresh `ReservationTimeSlot`
    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    if (shouldPopAfterAction) context.pop();
  }

  Future<void> showDelete(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        Text("${reservation.branchName} ${reservation.teacherID}"),
        const SizedBox(height: 8),
        Text(reservation.range.format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("수업을 삭제 하시겠습니까?"),
        const SizedBox(height: 8),
        const Text("취소 내역에 기록되지 않습니다"),
        const SizedBox(height: 24),
        const Text(
          "되돌릴 수 없습니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "취소와는 다른 기능입니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "강제로 예약 데이터를 삭제합니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "예상치 못한 오류가 발생할 수 있습니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "잘못 예약했을 경우 즉시 철회하는 용도로만 사용하는 것을 권장합니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    final isConfirmedAgain = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text(
          "정말로 삭제하시겠습니까?",
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
        .delete(reservation.id)
        .withLoadingOverlay(context);

    // refresh `UserDetailReservationList`
    ref.invalidate(termReservationsProvider);

    // refresh `ReservationTimeSlot`
    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    if (shouldPopAfterAction) context.pop();
  }
}
