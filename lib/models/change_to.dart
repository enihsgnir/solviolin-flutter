import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_to.freezed.dart';
part 'change_to.g.dart';

@freezed
class ChangeTo with _$ChangeTo {
  const factory ChangeTo({
    required DateTime startDate,
    required DateTime endDate,
  }) = _ChangeTo;

  const ChangeTo._();

  (DateTime, DateTime) get range => (startDate, endDate);

  factory ChangeTo.fromJson(Map<String, dynamic> json) =>
      _$ChangeToFromJson(json);
}
