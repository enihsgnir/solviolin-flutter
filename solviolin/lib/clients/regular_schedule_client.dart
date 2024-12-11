import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/regular_schedule.dart';

part 'regular_schedule_client.g.dart';

@RestApi(baseUrl: "regular-schedule")
abstract class RegularScheduleClient {
  factory RegularScheduleClient(Dio dio, {String baseUrl}) =
      _RegularScheduleClient;

  @GET("")
  @Extra({
    "404": "정기 스케줄을 찾을 수 없습니다",
  })
  Future<List<RegularSchedule>> getAllMine();

  @GET("/{userID}")
  @Extra({
    "404": "해당 유저의 정기 스케줄을 찾을 수 없습니다",
  })
  Future<List<RegularSchedule>> getAllByUserID(@Path() String userID);

  @DELETE("/{id}")
  @Extra({
    "400": "아직 시작하지 않은 정기 스케줄만 삭제할 수 있습니다",
    "404": "해당 정기 스케줄을 찾을 수 없습니다",
  })
  Future<void> delete(@Path() int id);
}
