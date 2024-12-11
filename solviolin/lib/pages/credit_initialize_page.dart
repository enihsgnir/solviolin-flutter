import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/client_state/user_state_provider.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class CreditInitializePage extends ConsumerWidget {
  const CreditInitializePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("크레딧 초기화"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: titleLarge,
              children: [
                TextSpan(text: "전 지점", style: TextStyle(color: red)),
                TextSpan(text: " 등록 수강생의 크레딧을"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: titleLarge,
              children: [
                TextSpan(text: "모두 "),
                TextSpan(text: "초기화", style: TextStyle(color: red)),
                TextSpan(text: " 하시겠습니까?"),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => showInitializeCredit(context, ref),
            style: FilledButton.styleFrom(backgroundColor: red),
            child: const Text("크레딧 초기화"),
          ),
        ],
      ),
    );
  }

  Future<void> showInitializeCredit(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: [
        const Text("크레딧 초기화를 진행합니다", style: titleLarge),
        const SizedBox(height: 16),
        Text(
          "되돌릴 수 없습니다",
          style: titleSmall.copyWith(color: red),
        ),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(userStateProvider.notifier)
        .initializeCredit()
        .withLoadingOverlay(context);

    if (!context.mounted) return;
    context.pop();
  }
}
