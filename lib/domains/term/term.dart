import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'term.freezed.dart';
part 'term.g.dart';

@freezed
class Term with _$Term {
  const factory Term({
    required int id,
    required DateTime termStart,
    required DateTime termEnd,
  }) = _Term;

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
}
