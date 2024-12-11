import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/ledger.dart';

part 'ledger_client.g.dart';

@RestApi(baseUrl: "ledger")
abstract class LedgerClient {
  factory LedgerClient(Dio dio, {String baseUrl}) = _LedgerClient;

  @GET("")
  Future<List<Ledger>> getAll({
    @Query("branchName") String? branchName,
    @Query("termID") int? termID,
    @Query("userID") String? userID,
  });

  @POST("")
  Future<void> create({
    @Field() required String branchName,
    @Field() required int termID,
    @Field() required String userID,
    @Field() required int amount,
  });

  @DELETE("/{id}")
  Future<void> delete(@Path() int id);

  @GET("/total")
  Future<String> getTotal({
    @Query("branchName") required String branchName,
    @Query("termID") required int termID,
  });
}
