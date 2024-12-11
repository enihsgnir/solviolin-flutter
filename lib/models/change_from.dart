import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_from.freezed.dart';
part 'change_from.g.dart';

@freezed
class ChangeFrom with _$ChangeFrom {
  const factory ChangeFrom({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
  }) = _ChangeFrom;

  const ChangeFrom._();

  (DateTime, DateTime) get range => (startDate, endDate);

  factory ChangeFrom.fromJson(Map<String, dynamic> json) =>
      _$ChangeFromFromJson(json);
}
