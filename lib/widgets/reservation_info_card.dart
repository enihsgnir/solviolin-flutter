import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/models/reservation.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';

class ReservationInfoCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationInfoCard(
    this.reservation, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("수업 정보", style: titleLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("강사: "),
            Text("${reservation.branchName} ${reservation.teacherID}"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("수강생: "),
            Text(reservation.userID),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("날짜:"),
            Text(reservation.range.format(dateTimeRange)),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.pop(),
            child: const Text("확인"),
          ),
        ),
      ],
    );
  }
}
