import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/check_in.dart';
import 'package:solviolin/models/dto/check_in_search_request.dart';

part 'check_in_client.g.dart';

@RestApi(baseUrl: "check-in")
abstract class CheckInClient {
  factory CheckInClient(Dio dio, {String baseUrl}) = _CheckInClient;

  @POST("")
  Future<void> checkIn(@Field() String branchCode);

  @POST("/search")
  Future<List<CheckIn>> search({
    @Body() required CheckInSearchRequest data,
  });
}
