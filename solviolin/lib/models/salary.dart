import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/salary_info.dart';

part 'salary.freezed.dart';

@freezed
class Salary with _$Salary {
  const factory Salary({
    required String teacherID,
    required SalaryInfo info,
  }) = _Salary;

  factory Salary.fromJson(List<dynamic> json) {
    return Salary(
      teacherID: json[0] as String,
      info: SalaryInfo.fromJson(json[1] as Map<String, dynamic>),
    );
  }
}
