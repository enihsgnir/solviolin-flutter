import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:solviolin/model/change.dart';
import 'package:solviolin/model/profile.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/term.dart';
import 'package:solviolin/util/format.dart';

class Client {
  final Dio dio = Dio();
  final FlutterSecureStorage storage = Get.find<FlutterSecureStorage>();

  Client() {
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = "https://xn--sy2bt7bxwhpof3wb.com";

    // not to get breakpoints at error
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status! < 600;

    dio.interceptors.add(PrettyDioLogger(request: false));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (await isLoggedIn()) {
          options.headers["Authorization"] =
              "Bearer ${await storage.read(key: "accessToken")}";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        bool containsAccess = await storage.containsKey(key: "accessToken");
        bool containsRefresh = await storage.containsKey(key: "refreshToken");

        if (response.statusCode == 401) {
          if (containsAccess && containsRefresh) {
            try {
              await refresh();
              return handler.next(await retry(response.requestOptions));
            } on NetworkException catch (e) {
              return handler.reject(e);
            }
          } else if (!containsAccess && containsRefresh) {
            Get.offAllNamed("/login");
            await logout();

            return handler.reject(NetworkException._(
              message: "인증이 만료되었습니다. 자동으로 로그아웃 됩니다.",
              options: response.requestOptions,
            ));
          }
        } else if (response.statusCode != 200 && response.statusCode != 201) {
          var message = response.data["message"];
          if (message is List<dynamic>) {
            message = message.join("\n");
          }

          return handler.reject(NetworkException._(
            message: message,
            options: response.requestOptions,
          ));
        }

        return handler.next(response);
      },
    ));
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
        String accessToken = response.data["access_token"];
        await storage.write(key: "accessToken", value: accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
      }
    }
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    return await dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  Future<void> logout() async {
    if (await isLoggedIn()) {
      await dio.patch("/auth/log-out");
    }
    await storage.deleteAll();
    dio.options.headers.remove("Authorization");
  }

  Future<Profile> login(String userID, String userPassword) async {
    Response response = await dio.post("/auth/login", data: {
      "userID": userID,
      "userPassword": userPassword,
    });
    if (response.statusCode == 201) {
      if (response.data["userType"] == 0) {
        await storage.write(
            key: "accessToken", value: response.data["access_token"]);
        await storage.write(
            key: "refreshToken", value: response.data["refresh_token"]);
        return Profile.fromJson(response.data);
      } else {
        throw "강사 및 관리자는 별도의 앱을 이용하기 바랍니다.";
      }
    }
    throw "내 정보를 불러올 수 없습니다.";
  }

  Future<Profile> getProfile() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/auth/profile");
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      }
    }
    throw "내 정보를 불러올 수 없습니다.";
  }

  Future<List<RegularSchedule>> getRegularSchedules() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/regular-schedule");
      if (response.statusCode == 200) {
        return List<RegularSchedule>.generate(
          response.data.length,
          (index) => RegularSchedule.fromJson(response.data[index]),
        );
      }
    }
    throw "내 정규 일정을 불러올 수 없습니다.";
  }

  Future<List<DateTime>> getAvailableSpots({
    required String branchName,
    required String teacherID,
    required DateTime startDate,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/reservation/available", data: {
        "branchName": branchName,
        "teacherID": teacherID,
        "startDate": startDate.toIso8601String(),
      });
      if (response.statusCode == 201) {
        return List<DateTime>.generate(
          response.data.length,
          (index) => parseDateTime(response.data[index]),
        );
      }
    }
    throw "예약 가능한 시간대를 불러올 수 없습니다.";
  }

  Future<List<Reservation>> getReservations({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    String? userID,
    required List<int> bookingStatus,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post(
        "/reservation/search",
        data: {
          "branchName": branchName,
          "teacherID": teacherID,
          "startDate": startDate?.toIso8601String(),
          "endDate": endDate?.toIso8601String(),
          "userID": userID,
          "bookingStatus": bookingStatus,
        }..removeWhere((key, value) => value == null),
      );
      if (response.statusCode == 201) {
        return List<Reservation>.generate(
          response.data.length,
          (index) => Reservation.fromJson(response.data[index]),
        );
      }
    }
    throw "예약 내역을 불러올 수 없습니다.";
  }

  Future<List<Change>> getChanges({String range = "both"}) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/reservation/changes", data: {
        "range": range,
      });
      if (response.statusCode == 201) {
        return List<Change>.generate(
          response.data.length,
          (index) => Change.fromJson(response.data[index]),
        );
      }
    }
    throw "변경 내역을 불러올 수 없습니다.";
  }

  Future<List<Term>> getCurrentTerm() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/term");
      if (response.statusCode == 200) {
        return List<Term>.generate(
          response.data.length,
          (index) => Term.fromJson(response.data[index]),
        );
      }
    }
    throw "현재 학기 정보를 불러올 수 없습니다.";
  }

  Future<void> makeUpReservation({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/user", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
    }
  }

  Future<void> cancelReservation(int id) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/user/cancel/$id");
    }
  }

  Future<void> extendReservation(int id) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/user/extend/$id");
    }
  }

  Future<void> checkIn(String branchCode) async {
    if (await isLoggedIn()) {
      await dio.post("/check-in", data: {
        "branchCode": branchCode,
      });
    }
  }
}

class NetworkException extends DioError {
  String message;
  RequestOptions options;

  NetworkException({
    required this.message,
    required this.options,
  }) : super(
          requestOptions: options,
          type: DioErrorType.response,
        );

  factory NetworkException._({
    required String message,
    required RequestOptions options,
  }) {
    return NetworkException(
      message: message,
      options: options,
    );
  }

  @override
  String toString() => message;
}
