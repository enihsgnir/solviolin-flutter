import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/term_update_form_provider.dart';
import 'package:solviolin_common/providers/term_list_provider.dart';
import 'package:solviolin_common/providers/term_provider.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/date_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class TermUpdatePage extends ConsumerWidget {
  final int id;

  const TermUpdatePage(
    this.id, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(termProvider(id)).valueOrNull;

    final enabled = ref.watch(
      termUpdateFormProvider(id).select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("학기 수정"),
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
            initialValue: term?.termStart,
            onChanged: (value) => ref
                .read(termUpdateFormProvider(id).notifier)
                .setTermStart(value),
          ),
          const FormTitle("종료일", isRequired: true),
          DateSelectField(
            initialValue: term?.termEnd,
            onChanged: (value) =>
                ref.read(termUpdateFormProvider(id).notifier).setTermEnd(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showUpdate(context, ref) : null,
            child: const Text("수정"),
          ),
        ],
      ),
    );
  }

  Future<void> showUpdate(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("학기를 수정하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(termUpdateFormProvider(id).notifier)
        .submit()
        .withLoadingOverlay(context);

    ref.invalidate(termListProvider);

    if (!context.mounted) return;
    context.pop();
  }
}
