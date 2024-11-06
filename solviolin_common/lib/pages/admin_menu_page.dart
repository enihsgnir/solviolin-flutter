import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin_common/widgets/menu_button.dart';
import 'package:solviolin_common/widgets/menu_section_title.dart';
import 'package:solviolin_common/widgets/sign_out_button.dart';

class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("관리자 메뉴"),
        actions: const [SignOutButton()],
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const MenuSectionTitle("수업 관리"),
          MenuButton(
            label: "예약 슬롯",
            onTap: () => context.push("/admin/reservation"),
          ),
          MenuButton(
            label: "취소 내역 검색",
            onTap: () => context.push("/admin/canceled/search"),
          ),
          MenuButton(
            label: "지점의 수업을 다음 학기로 연장하기",
            onTap: () => context.push("/admin/term/extend/branch"),
          ),
          MenuButton(
            label: "수강생의 수업을 다음 학기로 연장하기",
            onTap: () => context.push("/admin/term/extend/student"),
          ),
          const MenuSectionTitle("유저"),
          MenuButton(
            label: "유저 검색",
            onTap: () => context.push("/admin/user/search"),
          ),
          MenuButton(
            label: "유저 신규 등록",
            onTap: () => context.push("/admin/user/register"),
          ),
          MenuButton(
            label: "크레딧 초기화",
            onTap: () => context.push("/admin/credit/initialize"),
          ),
          const MenuSectionTitle("매출"),
          MenuButton(
            label: "매출 검색",
            onTap: () => context.push("/admin/ledger/search"),
          ),
          MenuButton(
            label: "원비 납부",
            onTap: () => context.push("/admin/ledger/create"),
          ),
          MenuButton(
            label: "매출 총액 조회",
            onTap: () => context.push("/admin/ledger/total"),
          ),
          const MenuSectionTitle("강사 스케줄"),
          MenuButton(
            label: "강사 스케줄 검색",
            onTap: () => context.push("/admin/teacher/search"),
          ),
          MenuButton(
            label: "강사 스케줄 등록",
            onTap: () => context.push("/admin/teacher/register"),
          ),
          const MenuSectionTitle("오픈/클로즈"),
          MenuButton(
            label: "오픈/클로즈 검색",
            onTap: () => context.push("/admin/control/search"),
          ),
          MenuButton(
            label: "오픈/클로즈 등록",
            onTap: () => context.push("/admin/control/register"),
          ),
          const MenuSectionTitle("강사 급여"),
          MenuButton(
            label: "급여 계산",
            onTap: () => context.push("/admin/salary/search"),
          ),
          const MenuSectionTitle("학기"),
          MenuButton(
            label: "학기 목록",
            onTap: () => context.push("/admin/terms"),
          ),
          MenuButton(
            label: "학기 등록",
            onTap: () => context.push("/admin/term/register"),
          ),
          const MenuSectionTitle("지점"),
          MenuButton(
            label: "지점 목록",
            onTap: () => context.push("/admin/branches"),
          ),
          MenuButton(
            label: "지점 등록",
            onTap: () => context.push("/admin/branch/register"),
          ),
          const MenuSectionTitle("체크인"),
          MenuButton(
            label: "QR 체크인",
            onTap: () => context.push("/check-in"),
          ),
          MenuButton(
            label: "체크인 이력 검색",
            onTap: () => context.push("/admin/check-in/search"),
          ),
          const MenuSectionTitle("기타"),
          MenuButton(
            label: "메트로놈",
            onTap: () => context.push("/metronome"),
          ),
        ],
      ),
    );
  }
}
