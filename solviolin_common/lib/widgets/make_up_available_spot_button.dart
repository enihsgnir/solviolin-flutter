import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/regular_schedule.dart';
import 'package:solviolin_common/providers/available_spots_provider.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/my_valid_reservations_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class MakeUpAvailableSpotButton extends ConsumerWidget {
  final RegularSchedule regularSchedule;
  final DateTime spot;

  const MakeUpAvailableSpotButton({
    super.key,
    required this.regularSchedule,
    required this.spot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () => showReserve(context, ref),
      style: FilledButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        spot.format(time),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> showReserve(BuildContext context, WidgetRef ref) async {
    final duration = regularSchedule.endTime - regularSchedule.startTime;
    final end = spot.add(duration);

    final isConfirmed = await showConfirmationDialog(
      context,
      content: [
        Text("${regularSchedule.branchName} ${regularSchedule.teacherID}"),
        const SizedBox(height: 8),
        Text((spot, end).format(dateTimeRange)),
        const SizedBox(height: 8),
        const Text("보강을 예약 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationStateProvider.notifier)
        .makeUp(
          teacherID: regularSchedule.teacherID,
          branchName: regularSchedule.branchName,
          startDate: spot,
          endDate: end,
          userID: regularSchedule.userID,
        )
        .withLoadingOverlay(context);

    ref.invalidate(myValidReservationsProvider);
    ref.invalidate(availableSpotsProvider);
  }
}
