import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin_common/models/dto/term_create_request.dart';
import 'package:solviolin_common/models/term.dart';

part 'term_client.g.dart';

@RestApi(baseUrl: "term")
abstract class TermClient {
  factory TermClient(Dio dio, {String baseUrl}) = _TermClient;

  /// Returns terms sorted in descending order by the number of `take`.
  ///
  /// If `take` is zero, it returns all terms.
  @GET("/{take}")
  Future<List<Term>> getAll(@Path() int take);

  @POST("")
  @Extra({
    "409": "해당 기간에 학기가 이미 등록되어 있습니다",
  })
  Future<void> register({
    @Body() required TermCreateRequest data,
  });
}
