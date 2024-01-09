import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/check_in/check_in.dart';
import 'package:solviolin/utils/client.dart';

part 'check_in_client.g.dart';

@RestApi(baseUrl: "$baseUrl/check_in")
abstract class CheckInClient {
  factory CheckInClient(Dio dio, {String baseUrl}) = _CheckInClient;

  @POST("")
  Future<void> checkIn({
    @Field() required String branchCode,
  });

  @POST("/search")
  Future<List<CheckIn>> getCheckInHistories({
    @Field() required String branchName,
    @Field() DateTime? startDate,
    @Field() DateTime? endDate,
  });
}
