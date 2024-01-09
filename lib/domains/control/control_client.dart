import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/control/control.dart';
import 'package:solviolin/domains/control/dto/create_control_dto.dart';
import 'package:solviolin/domains/control/dto/search_control_dto.dart';
import 'package:solviolin/utils/client.dart';

part 'control_client.g.dart';

@RestApi(baseUrl: "$baseUrl/control")
abstract class ControlClient {
  factory ControlClient(Dio dio, {String baseUrl}) = _ControlClient;

  @POST("/search")
  Future<List<Control>> getControls(@Body() SearchControlDto data);

  @POST("")
  Future<void> registerControl(@Body() CreateControlDto data);

  @DELETE("/{id}")
  Future<void> deleteControl(@Path() int id);
}
