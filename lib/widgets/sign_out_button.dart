import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/client_state/auth_state_provider.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => showSignOut(context, ref),
      icon: const Icon(Icons.logout_rounded),
    );
  }

  Future<void> showSignOut(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("로그아웃 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    await ref.read(authStateProvider.notifier).signOut();
  }
}
