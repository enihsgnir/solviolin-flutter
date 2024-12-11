import 'package:json_annotation/json_annotation.dart';

enum Dow implements Comparable<Dow> {
  @JsonValue(0)
  sun("일"),

  @JsonValue(1)
  mon("월"),

  @JsonValue(2)
  tue("화"),

  @JsonValue(3)
  wed("수"),

  @JsonValue(4)
  thu("목"),

  @JsonValue(5)
  fri("금"),

  @JsonValue(6)
  sat("토"),
  ;

  final String label;

  const Dow(this.label);

  String get inline => "$label요일";

  @override
  int compareTo(Dow other) => index.compareTo(other.index);

  bool operator <(Dow other) => index < other.index;

  bool operator <=(Dow other) => index <= other.index;

  bool operator >(Dow other) => index > other.index;

  bool operator >=(Dow other) => index >= other.index;
}
