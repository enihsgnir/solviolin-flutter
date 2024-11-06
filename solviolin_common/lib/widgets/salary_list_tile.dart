import 'package:flutter/material.dart';
import 'package:solviolin_common/models/salary.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';

class SalaryListTile extends StatelessWidget {
  final Salary salary;

  const SalaryListTile(
    this.salary, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final day = salary.info.dayTime;
    final night = salary.info.nightTime;
    final income = salary.info.income.format(number);

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
              Text(salary.teacherID, style: titleMedium),
              const Text("(30분 기준)", style: captionLarge),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("주간 근로 시간:"),
              Text("${day ~/ 60}시간 ${day % 60}분 (${day / 30}회)"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("야간 근로 시간:"),
              Text("${night ~/ 60}시간 ${night % 60}분 (${night / 30}회)"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("급여:"),
              Text("$income원", style: titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
