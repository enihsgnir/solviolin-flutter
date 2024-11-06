import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin_common/models/dto/auth_refresh_response.dart';
import 'package:solviolin_common/models/dto/auth_sign_in_response.dart';
import 'package:solviolin_common/models/profile.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: "auth")
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST("/login")
  @Extra({
    "type": "sign_in",
    "401": "아이디 또는 비밀번호가 올바르지 않습니다",
    "404": "아이디 또는 비밀번호가 올바르지 않습니다",
  })
  Future<AuthSignInResponse> signIn({
    @Field() required String userID,
    @Field() required String userPassword,
  });

  @GET("/profile")
  @Extra({
    "404": "존재하지 않는 계정입니다\n앱을 다시 실행해주세요",
  })
  Future<Profile> getProfile();

  @POST("/refresh")
  @Extra({
    "type": "token_refresh",
    "401": "인증이 만료되어 자동으로 로그아웃 합니다",
  })
  Future<AuthRefreshResponse> refresh(@Field() String refreshToken);

  @PATCH("/log-out")
  Future<void> signOut();
}
