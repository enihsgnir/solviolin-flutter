import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/converters/local_date_time_converter.dart';

part 'check_in.freezed.dart';
part 'check_in.g.dart';

@freezed
class CheckIn with _$CheckIn {
  const factory CheckIn({
    required int id,
    required String userID,
    required String branchName,
    @LocalDateTimeConverter() required DateTime createdAt,
  }) = _CheckIn;

  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      _$CheckInFromJson(json);
}
