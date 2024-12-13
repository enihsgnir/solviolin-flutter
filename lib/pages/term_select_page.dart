import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/term_list_provider.dart';
import 'package:solviolin/widgets/menu_button.dart';
import 'package:solviolin/widgets/status_widget.dart';

class TermSelectPage extends ConsumerWidget {
  const TermSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termList = ref.watch(termListProvider);

    final child = termList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "학기가 없습니다",
            subtitle: "학기를 추가해주세요",
          );
        }

        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final term = data[index];
            return MenuButton(
              label: term.inline,
              onTap: () => context.pop(term),
            );
          },
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
        title: const Text("학기 선택"),
      ),
      body: child,
    );
  }
}
