import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/control_search_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/control_status_multi_select_field.dart';
import 'package:solviolin/widgets/date_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/teacher_id_select_field.dart';

class ControlSearchPage extends ConsumerWidget {
  const ControlSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      controlSearchFormProvider.select((value) => value.enabled),
    );

    final branchName = ref.watch(
      controlSearchFormProvider.select((value) => value.branchName),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("오픈/클로즈 검색"),
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
                .read(controlSearchFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("강사"),
          TeacherIDSelectField(
            branchName: branchName,
            onChanged: (value) => ref
                .read(controlSearchFormProvider.notifier)
                .setTeacherID(value),
          ),
          const FormTitle("시작일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(controlSearchFormProvider).controlStart,
            onChanged: (value) => ref
                .read(controlSearchFormProvider.notifier)
                .setControlStart(value),
          ),
          const FormTitle("종료일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(controlSearchFormProvider).controlEnd,
            onChanged: (value) => ref
                .read(controlSearchFormProvider.notifier)
                .setControlEnd(value),
          ),
          const FormTitle("오픈/클로즈"),
          ControlStatusMultiSelectField(
            onChanged: (value) =>
                ref.read(controlSearchFormProvider.notifier).setStatus(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/control/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
