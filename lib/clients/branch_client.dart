import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/models/branch.dart';

part 'branch_client.g.dart';

@RestApi(baseUrl: "branch")
abstract class BranchClient {
  factory BranchClient(Dio dio, {String baseUrl}) = _BranchClient;

  @GET("")
  Future<List<Branch>> getAll();

  @POST("")
  Future<void> register(@Field() String branchName);
}
