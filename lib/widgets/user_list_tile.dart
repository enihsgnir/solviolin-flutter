import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';

class UserListTile extends StatelessWidget {
  final User user;

  const UserListTile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final userID = user.userID;
    final phone = user.userPhone.format(phoneNumber);
    final paidAt = user.paidAt;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${user.branchName} $userID"),
              IconButton(
                onPressed: () =>
                    context.push("/admin/user/search/result/$userID"),
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("연락처:"),
              Text(phone),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("등록 상태:"),
              Text(
                user.status.label,
                style: TextStyle(
                  color: user.status == UserStatus.unregistered ? red : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("크레딧:"),
              Text("${user.userCredit}"),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("해당 학기 결제 시각:"),
              Text(
                paidAt == null ? "미결제" : paidAt.format(dateTime),
                style: TextStyle(
                  color: paidAt == null ? red : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
