import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary.freezed.dart';
part 'salary.g.dart';

@freezed
class Salary with _$Salary {
  const factory Salary({
    required String teacherID,
    required SalaryInfo info,
  }) = _Salary;

  const Salary._();

  num get dayTime => info.dayTime;
  num get nightTime => info.nightTime;
  num get income => info.income;

  factory Salary.fromJson(dynamic json) {
    final list = json as List<dynamic>;
    return Salary(
      teacherID: list[0] as String,
      info: SalaryInfo.fromJson(list[1] as Map<String, dynamic>),
    );
  }

  List<dynamic> toJson() {
    return [teacherID, info.toJson()];
  }
}

@freezed
class SalaryInfo with _$SalaryInfo {
  const factory SalaryInfo({
    required num dayTime,
    required num nightTime,
    required num income,
  }) = _SalaryInfo;

  factory SalaryInfo.fromJson(Map<String, dynamic> json) =>
      _$SalaryInfoFromJson(json);
}
