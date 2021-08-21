import 'package:solviolin/util/format.dart';

class Term {
  DateTime termStart;
  DateTime termEnd;

  Term({
    required this.termStart,
    required this.termEnd,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      termStart: parseDateOnly(json["termStart"]),
      termEnd: parseDateOnly(json["termEnd"]),
    );
  }
}
