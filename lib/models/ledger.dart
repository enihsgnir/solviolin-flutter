import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/converters/local_date_time_converter.dart';

part 'ledger.freezed.dart';
part 'ledger.g.dart';

@freezed
class Ledger with _$Ledger {
  const factory Ledger({
    required int id,
    required int amount,
    required String userID,
    required int termID,
    required String branchName,
    @LocalDateTimeConverter() required DateTime paidAt,
  }) = _Ledger;

  factory Ledger.fromJson(Map<String, dynamic> json) => _$LedgerFromJson(json);
}
