import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/canceled_search_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/teacher_id_select_field.dart';

class CanceledSearchPage extends HookConsumerWidget {
  const CanceledSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      canceledSearchFormProvider.select((value) => value.enabled),
    );

    final branchName = useState("");

    return Scaffold(
      appBar: AppBar(
        title: const Text("취소 내역 검색"),
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
            onChanged: (value) => branchName.value = value,
          ),
          const FormTitle("강사", isRequired: true),
          TeacherIDSelectField(
            branchName: branchName.value,
            onChanged: (value) => ref
                .read(canceledSearchFormProvider.notifier)
                .setTeacherID(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/canceled/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
