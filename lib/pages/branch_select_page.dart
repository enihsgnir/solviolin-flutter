import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/branch_list_provider.dart';
import 'package:solviolin/widgets/menu_button.dart';
import 'package:solviolin/widgets/status_widget.dart';

class BranchSelectPage extends ConsumerWidget {
  const BranchSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchList = ref.watch(branchListProvider);

    final child = branchList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "지점이 없습니다",
            subtitle: "지점을 추가해주세요",
          );
        }

        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final branchName = data[index];

            return MenuButton(
              label: branchName,
              onTap: () => context.pop(branchName),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "지점을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("지점 선택"),
      ),
      body: child,
    );
  }
}
