import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/user.dart';

class Client {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  Client() {
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = "http://3.36.254.21";

    // not to get breakpoints at dioError
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status! < 500;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (await isLoggedIn()) {
          options.headers["Authorization"] =
              "Bearer ${await storage.read(key: "accessToken")}";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == 400) {
          print("정보를 불러올 수 없습니다.\n다시 확인해 주세요!");
          Get.defaultDialog(
            title: "정보를 불러올 수 없습니다.\n다시 확인해 주세요!",
          );
        } else if (response.statusCode == 401) {
          bool containsAccess = await storage.containsKey(key: "accessToken");
          bool containsRefresh = await storage.containsKey(key: "refreshToken");
          if (!containsAccess && !containsRefresh) {
            print("dialog: login failed");
          } else if (!containsAccess && containsRefresh) {
            print("dialog: refreshToken expired");
          } else if (containsAccess && containsRefresh) {
            print("do refresh");
            refresh();
          } else {
            print("containsAccess && !containsRefresh => bug?");
          }
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        print(error);
        return handler.next(error);
      },
    ));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));
  }

  Future<User> login(String userID, String userPassword) async {
    Response response = await dio.post("/auth/login", data: {
      "userID": userID,
      "userPassword": userPassword,
    });
    if (response.statusCode == 201) {
      User user = User.fromJson(response.data);
      await storage.write(key: "accessToken", value: user.accessToken);
      await storage.write(key: "refreshToken", value: user.refreshToken);
      return user;
    } else if (response.statusCode == 401) {
      print("아이디 패스워드 틀림");
    } else if (response.statusCode == 404) {
      print("유저 존재하지 않음");
    }
    print("LoadingFail");
    return Future.value(null);
  }

  Future<bool> isLoggedIn() async {
    return await storage.containsKey(key: "accessToken");
  }

  Future<void> refresh() async {
    String? refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken != null) {
      await storage.delete(key: "accessToken");
      Response response = await dio.post("/auth/refresh", data: {
        "refreshToken": refreshToken,
      });
      if (response.statusCode == 201) {
        String? accessToken = response.data["access_token"];
        await storage.write(key: "accessToken", value: accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
      } else if (response.statusCode == 401) {
        logout();
      }
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    dio.options.headers.remove("Authorization");
  }

  Future<User> getProfile() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/auth/profile");
      if (response.statusCode == 201) {
        User user = User.fromJson(response.data);
        await storage.write(key: "accessToken", value: user.accessToken);
        await storage.write(key: "refreshToken", value: user.refreshToken);
        return user;
      } else if (response.statusCode == 401) {
        await storage.deleteAll();
        print("token is invalid");
      } else if (response.statusCode == 404) {
        print("유저 존재하지 않음");
      }
    }
    print("로그인에 실패했습니다");
    return Future.value(null);
  }

  Future<List<Reservation>> getReservations(
    String branchName, {
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    String? userID,
  }) async {
    if (await isLoggedIn()) {
      List<Reservation> reservations = [];
      Map<String, dynamic> queries = {"branchName": branchName};
      if (teacherID != null) {
        queries["teacherID"] = teacherID;
      }
      if (startDate != null) {
        queries["startDate"] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queries["endDate"] = endDate.toIso8601String();
      }
      if (userID != null) {
        queries["userID"] = userID;
      }
      Response response =
          await dio.get("/reservation", queryParameters: queries);
      if (response.statusCode == 200) {
        var result = response.data;
        for (int i = 0; i < result.length; i++) {
          reservations.add(Reservation.fromJson(result[i]));
        }
        return reservations;
      }
    }
    print("LoadingFail");
    return Future.value(null);
  }

  Future<RegularSchedule> getRegularSchedule() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/regular-schedule");
      if (response.statusCode == 201) {
        return RegularSchedule.fromJson(response.data);
      }
    }
    print("LoadingFail");
    return Future.value(null);
  }

  Future<Teacher> getTeacher({String? teacherID, String? branchName}) async {
    if (await isLoggedIn()) {
      Map<String, dynamic> queries = {};
      if (teacherID != null) {
        queries["teacherID"] = teacherID;
      }
      if (branchName != null) {
        queries["branchName"] = branchName;
      }
      Response response =
          await dio.get("/teacher/search", queryParameters: queries);
      if (response.statusCode == 201) {
        return Teacher.fromJson(response.data);
      }
    }
    print("LoadingFail");
    return Future.value(null);
  }
}
