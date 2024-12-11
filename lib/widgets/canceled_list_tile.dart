import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/canceled.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';

class CanceledListTile extends ConsumerWidget {
  final Canceled canceled;

  const CanceledListTile(
    this.canceled, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const Text("강사:"),
              Text("${canceled.branchName} ${canceled.teacherID}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("수강생:"),
              Text(canceled.userID),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("기존 수업 시간:"),
              Text(canceled.range.format(dateTimeRange)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("보강:"),
              const Spacer(),
              Text(
                canceled.toIDs.isEmpty ? "보강 미예약" : "[ ... ]",
                style: const TextStyle(color: gray600),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => context
                    .push("/admin/canceled/search/result/${canceled.id}"),
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
