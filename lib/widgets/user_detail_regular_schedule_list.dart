import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/regular_schedule_list_provider.dart';
import 'package:solviolin/widgets/regular_schedule_list_tile.dart';
import 'package:solviolin/widgets/status_widget.dart';

class UserDetailRegularScheduleList extends ConsumerWidget {
  final String? userID;

  const UserDetailRegularScheduleList({
    super.key,
    required this.userID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regularScheduleList = ref.watch(regularScheduleListProvider(userID));

    return regularScheduleList.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return const EmptyStatusWidget(
            title: "정기 수업이 없습니다",
          );
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              RegularScheduleListTile(data[index], isForAdmin: userID != null),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "정기 수업을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
