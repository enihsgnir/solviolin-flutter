import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/teacher_info_list_provider.dart';
import 'package:solviolin/widgets/menu_button.dart';
import 'package:solviolin/widgets/status_widget.dart';

class TeacherIDSelectPage extends ConsumerWidget {
  final String branchName;

  const TeacherIDSelectPage({
    super.key,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherInfoList = ref.watch(teacherInfoListProvider(branchName));

    final child = teacherInfoList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "강사가 없습니다",
            subtitle: "지점을 선택해주세요",
          );
        }

        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final teacherID = data[index].teacherID;
            return MenuButton(
              label: teacherID,
              onTap: () => context.pop(teacherID),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "강사를 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("강사 선택"),
      ),
      body: child,
    );
  }
}
