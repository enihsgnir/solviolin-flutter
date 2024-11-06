import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/change_from.dart';
import 'package:solviolin_common/models/change_to.dart';

part 'change.freezed.dart';
part 'change.g.dart';

@freezed
class Change with _$Change {
  const factory Change({
    required ChangeFrom from,
    ChangeTo? to,
  }) = _Change;

  factory Change.fromJson(Map<String, dynamic> json) => _$ChangeFromJson(json);
}
