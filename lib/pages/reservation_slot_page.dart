import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin/widgets/reservation_time_slot.dart';

class ReservationSlotPage extends ConsumerWidget {
  final bool isForTeacher;

  const ReservationSlotPage({
    super.key,
    this.isForTeacher = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchName = ref.watch(
      reservationSearchFormProvider.select((value) => value.branchName),
    );

    final titlePrefix = isForTeacher ? "내" : branchName;

    return Scaffold(
      appBar: AppBar(
        title: Text("$titlePrefix 예약 슬롯"),
        actions: [
          if (!isForTeacher)
            IconButton(
              onPressed: () => context.push("/admin/reservation/search"),
              icon: const Icon(Icons.search_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReservationTimeSlot(isForTeacher: isForTeacher),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
