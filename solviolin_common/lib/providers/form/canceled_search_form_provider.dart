import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/canceled_search_form_data.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/providers/profile_provider.dart';

part 'canceled_search_form_provider.g.dart';

@riverpod
class CanceledSearchForm extends _$CanceledSearchForm {
  @override
  CanceledSearchFormData build() {
    final profile = ref.watch(profileProvider).valueOrNull;
    if (profile != null && profile.userType == UserType.teacher) {
      return CanceledSearchFormData(
        teacherID: profile.userID,
      );
    }

    return const CanceledSearchFormData();
  }

  void setTeacherID(String value) {
    state = state.copyWith(teacherID: value);
  }
}
