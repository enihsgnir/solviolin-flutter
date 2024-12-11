import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/link.dart';

part 'canceled.freezed.dart';
part 'canceled.g.dart';

@freezed
class Canceled with _$Canceled {
  const factory Canceled({
    required int id,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
    required String teacherID,
    required String branchName,
    required List<Link> linkFrom,
  }) = _Canceled;

  const Canceled._();

  (DateTime, DateTime) get range => (startDate, endDate);

  List<int> get toIDs => linkFrom.map((e) => e.toID).toList();

  factory Canceled.fromJson(Map<String, dynamic> json) =>
      _$CanceledFromJson(json);
}
