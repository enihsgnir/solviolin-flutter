import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/term/term.dart';
import 'package:solviolin/utils/client.dart';

part 'term_client.g.dart';

@RestApi(baseUrl: "$baseUrl/term")
abstract class TermClient {
  factory TermClient(Dio dio, {String baseUrl}) = _TermClient;

  @POST("")
  Future<void> registerTerm({
    @Field() required DateTime termStart,
    @Field() required DateTime termEnd,
  });

  @GET("/{take}")
  Future<List<Term>> getTerms(@Path() int take);
}
