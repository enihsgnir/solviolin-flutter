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
}
