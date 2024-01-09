import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/teacher/dto/create_teacher_dto.dart';
import 'package:solviolin/domains/teacher/teacher.dart';
import 'package:solviolin/domains/teacher/teacher_info.dart';
import 'package:solviolin/utils/client.dart';

part 'teacher_client.g.dart';

@RestApi(baseUrl: "$baseUrl/teacher")
abstract class TeacherClient {
  factory TeacherClient(Dio dio, {String baseUrl}) = _TeacherClient;

  @POST("")
  Future<void> registerTeacher(@Body() CreateTeacherDto data);

  @DELETE("/{id}")
  Future<void> deleteTeacher(@Path() String id);

  @GET("/search")
  Future<List<Teacher>> getTeachers({
    @Query("teacherID") String? teacherID,
    @Query("branchName") String? branchName,
  });

  @GET("/search/name")
  Future<List<TeacherInfo>> getTeacherInfos({
    @Query("branchName") String? branchName,
  });
}
