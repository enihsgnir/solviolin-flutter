import 'package:flutter/widgets.dart';
import 'package:solviolin/models/change.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';

class ChangeListTile extends StatelessWidget {
  final Change change;

  const ChangeListTile(
    this.change, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final before = change.from.range.format(dateTimeRange);
    final after = change.to?.range.format(dateTimeRange);

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
              Text("${change.from.branchName} ${change.from.teacherID}"),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("변경 전:"),
              Text(before),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("변경 후:"),
              Text(
                after ?? "변경 사항이 없습니다",
                style: TextStyle(color: after == null ? gray600 : null),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
