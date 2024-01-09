import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/auth/profile.dart';
import 'package:solviolin/domains/auth/token.dart';
import 'package:solviolin/utils/client.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: "$baseUrl/auth")
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST("/login")
  Future<Profile> login({
    @Field() required String userID,
    @Field() required String userPassword,
  });

  @GET("/profile")
  Future<Profile> getProfile();

  @POST("/refresh")
  Future<Token> refresh({
    @Field() required String refreshToken,
  });

  @PATCH("/log-out")
  Future<void> logout();
}
