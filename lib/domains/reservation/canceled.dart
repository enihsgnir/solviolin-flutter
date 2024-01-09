import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canceled.freezed.dart';
part 'canceled.g.dart';

@freezed
class Canceled with _$Canceled {
  const factory Canceled({
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
    required String teacherID,
    required String branchName,
    required List<LinkFrom> linkFrom,
  }) = _Canceled;

  const Canceled._();

  List<int> get toID => linkFrom.map((e) => e.toID).toList();

  factory Canceled.fromJson(Map<String, dynamic> json) =>
      _$CanceledFromJson(json);
}

@freezed
class LinkFrom with _$LinkFrom {
  const factory LinkFrom({
    required int toID,
  }) = _LinkFrom;

  factory LinkFrom.fromJson(Map<String, dynamic> json) =>
      _$LinkFromFromJson(json);
}
