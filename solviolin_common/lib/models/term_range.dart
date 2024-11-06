import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/term.dart';
import 'package:solviolin_common/models/term_position.dart';

part 'term_range.freezed.dart';

@freezed
class TermRange with _$TermRange {
  const factory TermRange({
    required Term previous,
    required Term current,
    required Term next,
  }) = _TermRange;

  const TermRange._();

  Term at(TermPosition position) {
    return switch (position) {
      TermPosition.previous => previous,
      TermPosition.current => current,
      TermPosition.next => next,
    };
  }
}
