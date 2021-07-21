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
      termStart: DateTime.parse(json["termStart"]),
      termEnd: DateTime.parse(json["termEnd"]),
    );
  }
}
