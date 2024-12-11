import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/term_list_provider.dart';
import 'package:solviolin/widgets/edit_mode_toggle_button.dart';
import 'package:solviolin/widgets/result_count.dart';
import 'package:solviolin/widgets/status_widget.dart';
import 'package:solviolin/widgets/term_list_tile.dart';

class TermListPage extends HookConsumerWidget {
  const TermListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termList = ref.watch(termListProvider);

    final count = termList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final showActions = useState(false);

    final child = termList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "학기가 없습니다",
            subtitle: "학기를 추가해주세요",
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
          itemBuilder: (context, index) =>
              TermListTile(data[index], showActions: showActions.value),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "학기를 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("학기 목록"),
        actions: [
          EditModeToggleButton(
            enabled: showActions.value,
            onChanged: (value) => showActions.value = value,
          ),
        ],
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
