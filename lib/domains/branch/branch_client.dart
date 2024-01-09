import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solviolin/domains/branch/branch.dart';
import 'package:solviolin/utils/client.dart';

part 'branch_client.g.dart';

@RestApi(baseUrl: "$baseUrl/branch")
abstract class BranchClient {
  factory BranchClient(Dio dio, {String baseUrl}) = _BranchClient;

  @POST("")
  Future<void> registerBranch({
    @Field() required String branchName,
  });

  @GET("")
  Future<List<Branch>> getBranches();
}
