import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/control_status.dart';

part 'control_search_form_data.freezed.dart';

@freezed
class ControlSearchFormData with _$ControlSearchFormData {
  const factory ControlSearchFormData({
    @Default("") String branchName,
    String? teacherID,
    required DateTime controlStart,
    required DateTime controlEnd,
    ControlStatus? status,
  }) = _ControlSearchFormData;

  const ControlSearchFormData._();

  bool get enabled =>
      branchName.isNotEmpty &&
      (controlStart.isAtSameMomentAs(controlEnd) ||
          controlStart.isBefore(controlEnd));
}
