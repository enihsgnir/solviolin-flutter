import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin_common/widgets/menu_button.dart';
import 'package:solviolin_common/widgets/sign_out_button.dart';

class StudentMenuPage extends StatelessWidget {
  const StudentMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("수강생 메뉴"),
        actions: const [SignOutButton()],
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          MenuButton(
            label: "내 예약",
            onTap: () => context.push("/student/personal"),
          ),
          MenuButton(
            label: "수업 변경",
            onTap: () => context.push("/student/make-up"),
          ),
          MenuButton(
            label: "QR 체크인",
            onTap: () => context.push("/check-in"),
          ),
          MenuButton(
            label: "메트로놈",
            onTap: () => context.push("/metronome"),
          ),
        ],
      ),
    );
  }
}
