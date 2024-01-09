import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/user/dto/create_user_dto.dart';
import 'package:solviolin/domains/user/dto/search_user_query_dto.dart';
import 'package:solviolin/domains/user/dto/update_user_dto.dart';
import 'package:solviolin/domains/user/user.dart';
import 'package:solviolin/utils/client.dart';

part 'user_client.g.dart';

@RestApi(baseUrl: "$baseUrl/user")
abstract class UserClient {
  factory UserClient(Dio dio, {String baseUrl}) = _UserClient;

  @POST("")
  Future<void> registerUser(@Body() CreateUserDto data);

  @GET("")
  Future<List<User>> getUsers(@Queries() SearchUserQueryDto? query);

  @PATCH("/{userID}")
  Future<void> updateUserInformation(
    @Path() String userID,
    @Body() UpdateUserDto data,
  );

  @PATCH("/admin/reset")
  Future<void> resetPassword({
    @Field() required String userID,
    @Field() required String userPassword,
  });

  @PATCH("/terminate/teacher")
  Future<void> terminateTeacher({
    @Field() required String teacherID,
    @Field() required DateTime endDate,
  });

  @PATCH("/initialize/credit")
  Future<void> initializeCredit();
}
