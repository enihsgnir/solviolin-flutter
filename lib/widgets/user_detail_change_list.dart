import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/change_list_provider.dart';
import 'package:solviolin/widgets/change_list_tile.dart';
import 'package:solviolin/widgets/status_widget.dart';

class UserDetailChangeList extends ConsumerWidget {
  final String? userID;

  const UserDetailChangeList({
    super.key,
    required this.userID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeList = ref.watch(changeListProvider(userID));

    return changeList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "변경 내역이 없습니다",
          );
        }

        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16) + MediaQuery.of(context).padding,
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => ChangeListTile(data[index]),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "변경 내역을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
