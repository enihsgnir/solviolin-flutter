import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/converters/local_date_time_converter.dart';

part 'ledger_info.freezed.dart';
part 'ledger_info.g.dart';

@freezed
class LedgerInfo with _$LedgerInfo {
  const factory LedgerInfo({
    @LocalDateTimeConverter() required DateTime paidAt,
  }) = _LedgerInfo;

  factory LedgerInfo.fromJson(Map<String, dynamic> json) =>
      _$LedgerInfoFromJson(json);
}
