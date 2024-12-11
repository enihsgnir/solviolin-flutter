import 'package:json_annotation/json_annotation.dart';

enum PaymentStatus {
  @JsonValue(0)
  isNotPaid,

  @JsonValue(1)
  isPaid,
}
