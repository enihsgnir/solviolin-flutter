import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/models/term.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';

class TermListTile extends StatelessWidget {
  final Term term;
  final bool showActions;

  const TermListTile(
    this.term, {
    super.key,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final id = term.id;
    final start = term.termStart.format(dateTime);
    final end = term.termEnd.format(dateTime);

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
              Text("$id번째 학기"),
              if (showActions)
                TextButton(
                  onPressed: () => context.push("/admin/terms/$id/update"),
                  child: const Text("수정"),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text("$start 부터"),
          const SizedBox(height: 4),
          Text("$end 까지"),
        ],
      ),
    );
  }
}
