import 'package:flutter/material.dart';
import 'package:solviolin_common/models/reservation.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class CanceledMadeUpListTile extends StatelessWidget {
  final Reservation? reservation;

  const CanceledMadeUpListTile(
    this.reservation, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: buildContent(),
    );
  }

  Widget buildContent() {
    final reservation = this.reservation;
    if (reservation == null) {
      return const EmptyStatusWidget(
        title: "수업을 찾을 수 없습니다",
        subtitle: "최근 학기에 해당 ID의 수업이 없습니다",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${reservation.bookingStatus.label} 수업입니다",
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
            const Text("수강생:"),
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
      ],
    );
  }
}
