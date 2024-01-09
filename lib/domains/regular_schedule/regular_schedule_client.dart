import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/regular_schedule/regular_schedule.dart';
import 'package:solviolin/utils/client.dart';

part 'regular_schedule_client.g.dart';

@RestApi(baseUrl: "$baseUrl/regular-schedule")
abstract class RegularScheduleClient {
  factory RegularScheduleClient(Dio dio, {String baseUrl}) =
      _RegularScheduleClient;

  @DELETE("/{id}")
  Future<void> deleteRegularSchedule(@Path() int id);

  @GET("")
  Future<List<RegularSchedule>> getRegularSchedules();

  @GET("/{userID}")
  Future<List<RegularSchedule>> getRegularSchedulesByAdmin(
    @Path() String userID,
  );
}
