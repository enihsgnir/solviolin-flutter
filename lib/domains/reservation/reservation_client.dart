import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/reservation/canceled.dart';
import 'package:solviolin/domains/reservation/change.dart';
import 'package:solviolin/domains/reservation/dto/reservation_filter_dto.dart';
import 'package:solviolin/domains/reservation/reservation.dart';
import 'package:solviolin/domains/reservation/salary.dart';
import 'package:solviolin/utils/client.dart';

part 'reservation_client.g.dart';

@RestApi(baseUrl: "$baseUrl/reservation")
abstract class ReservationClient {
  factory ReservationClient(Dio dio, {String baseUrl}) = _ReservationClient;

  @PATCH("/user/cancel/{id}")
  Future<void> cancel(@Path() int id);

  @PATCH("/admin/cancel/{id}/{count}")
  Future<void> cancelReservationByAdmin(@Path() int id, @Path() int count);

  @POST("/user")
  Future<void> makeUp({
    @Field() required String teacherID,
    @Field() required String branchName,
    @Field() required DateTime startDate,
    @Field() required DateTime endDate,
    @Field() required String userID,
  });

  @POST("/admin")
  Future<void> makeUpReservationByAdmin({
    @Field() required String teacherID,
    @Field() required String branchName,
    @Field() required DateTime startDate,
    @Field() required DateTime endDate,
    @Field() required String userID,
  });

  @POST("/free")
  Future<void> reserveFreeCourse({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  });

  @PATCH("/user/extend/{id}")
  Future<void> extend(@Path() int id);

  @PATCH("/admin/extend/{id}/{count}")
  Future<void> extendReservationByAdmin(@Path() int id, @Path() int count);

  @POST("/search")
  Future<List<Reservation>> getReservations(@Body() ReservationFilterDto data);

  @POST("/available")
  Future<List<DateTime>> getAvailableSpots({
    @Field() required String branchName,
    @Field() required String teacherID,
    @Field() required DateTime startDate,
  });

  @POST("/changes")
  Future<List<Change>> getChanges({
    @Field() required String range,
  });

  @POST("/changes/{userID}")
  Future<List<Change>> getChangesWithID(
    @Path() String userID, {
    @Field() required String range,
  });

  @POST("/salary")
  Future<List<Salary>> getSalaries({
    @Field() required String branchName,
    @Field() required int termID,
    @Field() required int dayTimeCost,
    @Field() required int nightTimeCost,
  });

  @DELETE("")
  Future<void> deleteReservation({
    @Field() required List<int> ids,
  });

  @GET("/canceled/{teacherID}")
  Future<List<Canceled>> getCanceledReservations(@Path() String teacherID);

  @POST("/regular")
  Future<void> reserveRegularReservation({
    @Field() required String teacherID,
    @Field() required String branchName,
    @Field() required DateTime startDate,
    @Field() required DateTime endDate,
    @Field() required String userID,
  });

  @PATCH("/regular/{id}")
  Future<void> updateEndDateAndDeleteLaterCourse(
    @Path() int id, {
    @Field() required DateTime endDate,
  });

  @POST("/regular/extend/{branch}")
  Future<void> extendAllCoursesOfBranch(@Path() String branch);

  @POST("/regular/extend/user/{userID}")
  Future<void> extendAllCoursesOfUser(@Path() String userID);

  @PATCH("/term/{id}")
  Future<void> modifyTerm(
    @Path() int id, {
    @Field() required DateTime termStart,
    @Field() required DateTime termEnd,
  });
}
