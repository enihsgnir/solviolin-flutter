import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/control.dart';
import 'package:solviolin/models/dto/control_register_request.dart';
import 'package:solviolin/models/dto/control_search_request.dart';

part 'control_client.g.dart';

@RestApi(baseUrl: "control")
abstract class ControlClient {
  factory ControlClient(Dio dio, {String baseUrl}) = _ControlClient;

  @POST("/search")
  Future<List<Control>> search({
    @Body() required ControlSearchRequest data,
  });

  @POST("")
  Future<void> register({
    @Body() required ControlRegisterRequest data,
  });

  @DELETE("/{id}")
  Future<void> delete(@Path() int id);
}
