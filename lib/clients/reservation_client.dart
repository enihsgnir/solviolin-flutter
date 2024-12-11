import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/canceled.dart';
import 'package:solviolin/models/change.dart';
import 'package:solviolin/models/dto/available_spot_search_request.dart';
import 'package:solviolin/models/dto/reservation_create_request.dart';
import 'package:solviolin/models/dto/reservation_search_request.dart';
import 'package:solviolin/models/dto/reservation_update_request.dart';
import 'package:solviolin/models/dto/term_create_request.dart';
import 'package:solviolin/models/reservation.dart';

part 'reservation_client.g.dart';

@RestApi(baseUrl: "reservation")
abstract class ReservationClient {
  factory ReservationClient(Dio dio, {String baseUrl}) = _ReservationClient;

  /// Regardless of time zone of `startDate` and `endDate`,
  /// normalized datetime matters.
  @POST("/search")
  Future<List<Reservation>> search({
    @Body() required ReservationSearchRequest data,
  });

  /// Regardless of hour and minute, only the `date` of `startDate` matters.
  @POST("/available")
  Future<List<String>> getAvailableSpots({
    @Body() required AvailableSpotSearchRequest data,
  });

  @PATCH("/user/cancel/{id}")
  @Extra({
    "400": "수업 시작 4시간 전부터는 수업을 취소할 수 없습니다",
    "403": "현재 학기가 아닌 다른 학기의 수업은 취소할 수 없습니다",
    "404": "해당 수업을 찾을 수 없습니다",
    "405": "취소 가능 횟수를 초과하였습니다",
  })
  Future<void> cancel(@Path() int id);

  @PATCH("/admin/cancel/{id}/{count}")
  @Extra({
    "404": "해당 수업을 찾을 수 없습니다",
    "405": "취소 가능 횟수를 초과하였습니다",
  })
  Future<void> cancelByAdmin(
    @Path() int id, {
    @Path() required int count,
  });

  @POST("/user")
  @Extra({
    "400":
        "다음의 경우에 해당하는 잘못된 요청입니다\n1) 수업 시작 4시간 전부터는 보강을 예약할 수 없습니다\n2) 정기 스케줄이 평일 16시 이전에 해당하는 수강생은 16시 이전의 수업만 예약할 수 있습니다",
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
    "412":
        "다음의 경우에 해당하는 조건을 충족하지 않은 요청입니다\n1) 해당 시간대가 현재 닫힌 상태입니다\n2) 보강 가능한 횟수가 부족합니다",
  })
  Future<void> makeUp({
    @Body() required ReservationCreateRequest data,
  });

  @POST("/admin")
  @Extra({
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
    "412":
        "다음의 경우에 해당하는 조건을 충족하지 않은 요청입니다\n1) 해당 시간대가 현재 닫힌 상태입니다\n2) 보강 가능한 횟수가 부족합니다\n3) 입력값이 정기 스케줄의 데이터와 일치하지 않습니다",
  })
  Future<void> makeUpByAdmin({
    @Body() required ReservationCreateRequest data,
  });

  @PATCH("/user/extend/{id}")
  @Extra({
    "400": "수업 시작 4시간 전부터는 수업을 연장할 수 없습니다",
    "404": "해당 수업을 찾을 수 없습니다",
    "405": "이미 취소된 수업입니다",
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
    "412": "연장 가능한 횟수가 부족합니다",
  })
  Future<void> extend(@Path() int id);

  @PATCH("/admin/extend/{id}/{count}")
  @Extra({
    "400": "수업 시작 4시간 전부터는 수업을 연장할 수 없습니다",
    "404": "해당 수업을 찾을 수 없습니다",
    "405": "이미 취소된 수업입니다",
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
    "412": "연장 가능한 횟수가 부족합니다",
  })
  Future<void> extendByAdmin(
    @Path() int id, {
    @Path() required int count,
  });

  @POST("/regular")
  @Extra({
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
    "412": "해당 시간대가 현재 닫힌 상태입니다",
  })
  Future<void> reserveRegular({
    @Body() required ReservationCreateRequest data,
  });

  @POST("/free")
  @Extra({
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
  })
  Future<void> reserveFreeCourse({
    @Body() required ReservationCreateRequest data,
  });

  @PATCH("/regular/{id}")
  @Extra({
    "400": "종료일이 정기 스케줄의 시작일보다 클 수 없습니다",
    "404": "해당 정기 스케줄을 찾을 수 없습니다",
  })
  Future<void> updateEndDateAndDeleteLaterCourse(
    @Path() int id, {
    @Body() required ReservationUpdateRequest data,
  });

  @POST("/regular/extend/{branch}")
  @Extra({
    "404": "다음 학기가 등록되어 있지 않습니다",
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
  })
  Future<void> extendAllCoursesOfBranch(@Path() String branch);

  @POST("/regular/extend/user/{userID}")
  @Extra({
    "404": "다음 학기가 등록되어 있지 않습니다",
    "409": "해당 시간대에 이미 예약된 수업이 존재합니다",
  })
  Future<void> extendAllCoursesOfUser(@Path() String userID);

  @DELETE("")
  Future<void> delete({
    @Field() required List<int> ids,
  });

  @GET("/canceled/{teacherID}")
  Future<List<Canceled>> getAllCanceled({
    @Path() required String teacherID,
  });

  @POST("/changes")
  Future<List<Change>> getChanges({
    @Field() required String range,
  });

  @POST("/changes/{userID}")
  Future<List<Change>> getChangesByUserID(
    @Path() String userID, {
    @Field() required String range,
  });

  @POST("/salary")
  Future<dynamic> getSalaries({
    @Field() required String branchName,
    @Field() required int termID,
    @Field() required int dayTimeCost,
    @Field() required int nightTimeCost,
  });

  @PATCH("/term/{id}")
  @Extra({
    "400": "다음 학기만 수정할 수 있습니다",
  })
  Future<void> modifyTerm(
    @Path() int id, {
    @Body() required TermCreateRequest data,
  });
}
