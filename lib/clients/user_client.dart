import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/dto/teacher_terminate_request.dart';
import 'package:solviolin/models/dto/user_register_request.dart';
import 'package:solviolin/models/dto/user_search_query.dart';
import 'package:solviolin/models/dto/user_update_request.dart';
import 'package:solviolin/models/user.dart';

part 'user_client.g.dart';

@RestApi(baseUrl: "user")
abstract class UserClient {
  factory UserClient(Dio dio, {String baseUrl}) = _UserClient;

  @GET("")
  Future<List<User>> getAll({
    @Queries() required UserSearchQuery queries,
  });

  @POST("")
  @Extra({
    "409": "중복된 아이디 또는 전화번호가 이미 등록되어 있습니다",
  })
  Future<void> register({
    @Body() required UserRegisterRequest data,
  });

  @PATCH("/{userID}")
  @Extra({
    "400": "입력값이 없습니다. 다시 확인해주세요.",
    "409": "중복된 전화번호가 이미 등록되어 있습니다",
  })
  Future<void> update(
    @Path() String userID, {
    @Body() required UserUpdateRequest data,
  });

  @PATCH("/admin/reset")
  Future<void> resetPassword({
    @Field() required String userID,
    @Field() required String userPassword,
  });

  @PATCH("/initialize/credit")
  Future<void> initializeCredit();

  @PATCH("/terminate/teacher")
  @Extra({
    "404": "해당 강사를 찾을 수 없습니다",
  })
  Future<void> terminateTeacher({
    @Body() required TeacherTerminateRequest data,
  });
}
