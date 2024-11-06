import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/dow.dart';
import 'package:solviolin_common/widgets/menu_button.dart';

class DowSelectPage extends ConsumerWidget {
  const DowSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const dowList = Dow.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text("지점 선택"),
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: dowList.length,
        itemBuilder: (context, index) {
          final dow = dowList[index];

          return MenuButton(
            label: dow.inline,
            onTap: () => context.pop(dow),
          );
        },
      ),
    );
  }
}
