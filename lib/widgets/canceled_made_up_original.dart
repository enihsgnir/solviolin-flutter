import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/canceled_provider.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/status_widget.dart';

class CanceledMadeUpOriginal extends ConsumerWidget {
  final int canceledID;

  const CanceledMadeUpOriginal({
    super.key,
    required this.canceledID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canceled = ref.watch(canceledProvider(canceledID));

    final child = canceled.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("강사:"),
                Text("${data.branchName} ${data.teacherID}"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("수강생:"),
                Text(data.userID),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("기존 수업 시간:"),
                Text(data.range.format(dateTimeRange)),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "취소 내역을 찾을 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
