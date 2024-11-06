import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/branch_list_provider.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/result_count.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class BranchListPage extends ConsumerWidget {
  const BranchListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchList = ref.watch(branchListProvider);

    final count = branchList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final child = branchList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "지점이 없습니다",
            subtitle: "지점을 추가해주세요",
          );
        }

        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).padding.bottom,
          ),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: gray100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(data[index]),
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
        title: const Text("지점 목록"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResultCount(count),
          Expanded(child: child),
        ],
      ),
    );
  }
}
