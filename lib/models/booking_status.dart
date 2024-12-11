import 'package:json_annotation/json_annotation.dart';

enum BookingStatus {
  @JsonValue(0)
  regular("정기"),

  @JsonValue(1)
  madeUp("보강"),

  @JsonValue(2)
  canceled("취소된"),

  @JsonValue(3)
  extended("연장한"),

  @JsonValue(-1)
  madeUpByAdmin("관리자가 예약한 보강"),

  @JsonValue(-2)
  canceledByAdmin("관리자가 취소한"),

  @JsonValue(-3)
  extendedByAdmin("관리자가 연장한"),
  ;

  final String label;

  const BookingStatus(this.label);

  bool get isRegular => this == regular;
  bool get isMadeUp => this == madeUp || this == madeUpByAdmin;
  bool get isCanceled => this == canceled || this == canceledByAdmin;
  bool get isExtended => this == extended || this == extendedByAdmin;

  static List<BookingStatus> get all => values;
  static List<BookingStatus> get valid =>
      all.where((e) => !e.isCanceled).toList();
}
