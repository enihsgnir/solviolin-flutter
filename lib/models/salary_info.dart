import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_info.freezed.dart';
part 'salary_info.g.dart';

@freezed
class SalaryInfo with _$SalaryInfo {
  const factory SalaryInfo({
    required int dayTime,
    required int nightTime,
    required int income,
  }) = _SalaryInfo;

  factory SalaryInfo.fromJson(Map<String, dynamic> json) =>
      _$SalaryInfoFromJson(json);
}
