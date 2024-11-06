import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/sign_in_form_provider.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      signInFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox.square(
                dimension: 100,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("솔바이올린", style: titleLarge),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: "아이디를 입력하세요",
              ),
              onChanged: (value) =>
                  ref.read(signInFormProvider.notifier).setUserID(value),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: "비밀번호를 입력하세요",
              ),
              obscureText: true,
              onChanged: (value) =>
                  ref.read(signInFormProvider.notifier).setUserPassword(value),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: enabled
                    ? () async {
                        await ref
                            .read(signInFormProvider.notifier)
                            .submit()
                            .withLoadingOverlay(context);

                        if (!context.mounted) return;
                        context.go("/");
                      }
                    : null,
                child: const Text("로그인"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
