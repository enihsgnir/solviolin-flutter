import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/branch_list_provider.dart';
import 'package:solviolin_common/providers/form/branch_register_form_provider.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class BranchRegisterPage extends ConsumerWidget {
  const BranchRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      branchRegisterFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("지점 등록"),
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
          TextField(
            decoration: const InputDecoration(
              hintText: "지점명을 입력하세요",
            ),
            onChanged: (value) => ref
                .read(branchRegisterFormProvider.notifier)
                .setBranchName(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
        Text("지점을 등록하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(branchRegisterFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    ref.invalidate(branchListProvider);

    if (!context.mounted) return;
    context.pushReplacement("/admin/branches");
  }
}
