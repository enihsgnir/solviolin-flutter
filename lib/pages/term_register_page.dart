import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/term_register_form_provider.dart';
import 'package:solviolin/providers/term_list_provider.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/date_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class TermRegisterPage extends ConsumerWidget {
  const TermRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      termRegisterFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("학기 등록"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("시작일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(termRegisterFormProvider).termStart,
            onChanged: (value) =>
                ref.read(termRegisterFormProvider.notifier).setTermStart(value),
          ),
          const FormTitle("종료일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(termRegisterFormProvider).termEnd,
            onChanged: (value) =>
                ref.read(termRegisterFormProvider.notifier).setTermEnd(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showRegister(context, ref) : null,
            child: const Text("등록"),
          ),
        ],
      ),
    );
  }

  Future<void> showRegister(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("학기를 등록하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(termRegisterFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    ref.invalidate(termListProvider);

    if (!context.mounted) return;
    context.pushReplacement("/admin/terms");
  }
}
