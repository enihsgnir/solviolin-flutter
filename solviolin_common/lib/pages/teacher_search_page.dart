import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/teacher_search_form_provider.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/teacher_id_select_field.dart';

class TeacherSearchPage extends ConsumerWidget {
  const TeacherSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      teacherSearchFormProvider.select((value) => value.enabled),
    );

    final branchName = ref.watch(
      teacherSearchFormProvider.select((value) => value.branchName),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("강사 스케줄 검색"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("지점명", isRequired: true),
          BranchSelectField(
            onChanged: (value) => ref
                .read(teacherSearchFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("강사"),
          TeacherIDSelectField(
            branchName: branchName,
            onChanged: (value) => ref
                .read(teacherSearchFormProvider.notifier)
                .setTeacherID(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/teacher/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
