import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin_common/widgets/menu_button.dart';
import 'package:solviolin_common/widgets/sign_out_button.dart';

class TeacherMenuPage extends StatelessWidget {
  const TeacherMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("강사 메뉴"),
        actions: const [SignOutButton()],
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          MenuButton(
            label: "예약 슬롯",
            onTap: () => context.push("/teacher/reservation"),
          ),
          MenuButton(
            label: "취소 내역",
            onTap: () => context.push("/teacher/canceled"),
          ),
          MenuButton(
            label: "오픈/클로즈 내역",
            onTap: () => context.push("/teacher/control"),
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
