import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/term_extend_student_form_provider.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class TermExtendStudentPage extends ConsumerWidget {
  const TermExtendStudentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      termExtendStudentFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("정기 연장 (수강생)"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("수강생 아이디", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "수강생 아이디를 입력하세요",
            ),
            onChanged: (value) => ref
                .read(termExtendStudentFormProvider.notifier)
                .setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showExtend(context, ref) : null,
            child: const Text("연장"),
          ),
        ],
      ),
    );
  }

  Future<void> showExtend(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("정말로 연장하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(termExtendStudentFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    if (!context.mounted) return;
    context.pop();
  }
}
