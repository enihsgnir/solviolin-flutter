import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/term_position.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/providers/term_reservations_provider.dart';
import 'package:solviolin/widgets/reservation_list_tile.dart';
import 'package:solviolin/widgets/status_widget.dart';

class UserDetailReservationList extends ConsumerWidget {
  final User? user;
  final TermPosition position;

  const UserDetailReservationList({
    super.key,
    required this.user,
    required this.position,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(
      termReservationsProvider(user: user, position: position),
    );

    return reservations.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "예약 내역이 없습니다",
            subtitle: "예약을 추가해보세요",
          );
        }

        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16) + MediaQuery.of(context).padding,
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              ReservationListTile(data[index], isForAdmin: user != null),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "예약 내역을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
