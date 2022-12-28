import 'package:solviolin_admin/util/format.dart';

class Salary {
  String teacherID;
  num dayTime;
  num nightTime;
  num income;

  Salary({
    required this.teacherID,
    required this.dayTime,
    required this.nightTime,
    required this.income,
  });

  factory Salary.fromList(List<dynamic> list) {
    return Salary(
      teacherID: list[0].trim(),
      dayTime: list[1]["dayTime"],
      nightTime: list[1]["nightTime"],
      income: list[1]["income"],
    );
  }

  @override
  String toString() =>
      "$teacherID" +
      "\n주간근로시간: 30분 * " +
      formatWorkNumber(dayTime / 30) +
      "\n야간근로시간: 30분 * " +
      formatWorkNumber(nightTime / 30) +
      "\n급여: " +
      formatCurrency(income);
}
