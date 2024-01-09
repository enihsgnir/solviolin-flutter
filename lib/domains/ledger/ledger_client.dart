import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/ledger/ledger.dart';
import 'package:solviolin/utils/client.dart';

part 'ledger_client.g.dart';

@RestApi(baseUrl: "$baseUrl/ledger")
abstract class LedgerClient {
  factory LedgerClient(Dio dio, {String baseUrl}) = _LedgerClient;

  @POST("")
  Future<void> registerLedger({
    @Field() required String userID,
    @Field() required int amount,
    @Field() required int termID,
    @Field() required String branchName,
  });

  @GET("")
  Future<List<Ledger>> getLedgers({
    @Query("branchName") String? branchName,
    @Query("termID") int? termID,
    @Query("userID") String? userID,
  });

  @DELETE("/{id}")
  Future<void> deleteLedger(@Path() int id);

  @GET("/total")
  Future<num> getTotalLedger({
    @Query("branchName") required String branchName,
    @Query("termID") required int termID,
  });
}
