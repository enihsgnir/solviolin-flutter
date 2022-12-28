import 'package:solviolin_admin/util/format.dart';

class Term {
  int id;
  DateTime termStart;
  DateTime termEnd;

  Term({
    required this.id,
    required this.termStart,
    required this.termEnd,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      id: json["id"],
      termStart: parseDateTime(json["termStart"]),
      termEnd: parseDateTime(json["termEnd"]),
    );
  }

  @override
  String toString() =>
      "시작: " +
      formatDate(termStart) +
      "\n종료: " +
      formatDate(termEnd) +
      "\nID: $id";
}
