import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin_common/models/dto/teacher_register_request.dart';
import 'package:solviolin_common/models/teacher.dart';
import 'package:solviolin_common/models/teacher_info.dart';

part 'teacher_client.g.dart';

@RestApi(baseUrl: "teacher")
abstract class TeacherClient {
  factory TeacherClient(Dio dio, {String baseUrl}) = _TeacherClient;

  @GET("/search")
  Future<List<Teacher>> getAll({
    @Query("branchName") String? branchName,
    @Query("teacherID") String? teacherID,
  });

  @POST("")
  Future<void> register({
    @Body() required TeacherRegisterRequest data,
  });

  @DELETE("/{id}")
  Future<void> delete(@Path() int id);

  @GET("/search/name")
  Future<List<TeacherInfo>> getTeacherInfos({
    @Query("branchName") String? branchName,
  });
}
