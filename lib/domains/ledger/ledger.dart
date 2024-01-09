import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger.freezed.dart';
part 'ledger.g.dart';

@freezed
class Ledger with _$Ledger {
  const factory Ledger({
    required int id,
    required num amount,
    required String userID,
    required int termID,
    required String branchName,
    @LocalDateTimeConverter() required DateTime paidAt,
  }) = _Ledger;

  factory Ledger.fromJson(Map<String, dynamic> json) => _$LedgerFromJson(json);
}

class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
