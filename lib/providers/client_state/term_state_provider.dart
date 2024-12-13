import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/term_client.dart';
import 'package:solviolin/models/dto/term_create_request.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

part 'term_state_provider.g.dart';

@Riverpod(keepAlive: true)
class TermState extends _$TermState {
  @override
  TermClient build() {
    final dio = ref.watch(dioProvider);
    return TermClient(dio);
  }

  Future<void> register({
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    final data = TermCreateRequest(
      termStart: termStart,
      termEnd: termEnd,
    );
    await state.register(data: data);
  }
}
