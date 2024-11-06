import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/utils/formatters.dart';

part 'term.freezed.dart';
part 'term.g.dart';

@freezed
class Term with _$Term {
  const factory Term({
    required int id,
    required DateTime termStart,
    required DateTime termEnd,
  }) = _Term;

  const Term._();

  String get inline {
    final start = termStart.format(date);
    final end = termEnd.format(date);
    return "$id번째 - $start ~ $end";
  }

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
}
