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
  final dio = Dio();
  final storage = Get.find<FlutterSecureStorage>();

  Client() {
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = "https://xn--sy2bt7bxwhpof3wb.com";

    // not to get breakpoints at error
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status! < 600;

    dio.interceptors.add(PrettyDioLogger(request: false, requestBody: true));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (await isLoggedIn()) {
          options.headers["Authorization"] =
              "Bearer ${await storage.read(key: "accessToken")}";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        var accessible = await isLoggedIn();
        var refreshable = await storage.containsKey(key: "refreshToken");

        if (response.statusCode == 401 && accessible && refreshable) {
          try {
            await refresh();
            return handler.next(await retry(response.requestOptions));
          } on NetworkException catch (e) {
            return handler.reject(e);
          }
        } else if (response.statusCode == 401 && !accessible && refreshable) {
          Get.offAllNamed("/login");
          await logout();

          return handler.reject(NetworkException._(
            message: "인증이 만료되어 자동으로 로그아웃 합니다.",
            options: response.requestOptions,
          ));
        } else if (response.statusCode != 200 && response.statusCode != 201) {
          var message = response.data["message"];
          if (message is List<dynamic>) {
            message = message.join("\n");
          } else {
            message = message.toString();
          }

          return handler.reject(NetworkException._(
            message: message,
            options: response.requestOptions,
            response: response,
          ));
        }

        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.reject(NetworkException._(
          message: "아래 메시지와 함께 관리자에게 문의하세요!\n" + "DioError: ${error.message}",
          options: error.requestOptions,
        ));
      },
    ));
  }

  Future<bool> isLoggedIn() async {
    return await storage.containsKey(key: "accessToken");
  }

  Future<void> refresh() async {
    var refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken != null) {
      await storage.delete(key: "accessToken");
      var response = await dio.post("/auth/refresh", data: {
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
    var response = await dio.post("/auth/login", data: {
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
        throw NetworkException._(
          message: "강사 및 관리자는 별도의 앱을 이용하기 바랍니다.",
          options: response.requestOptions,
        );
      }
    }
    throw NetworkException._(
      message: "내 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<Profile> getProfile() async {
    var response = await dio.get("/auth/profile");
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data);
    }
    throw NetworkException._(
      message: "내 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<RegularSchedule>> getRegularSchedules() async {
    var response = await dio.get("/regular-schedule");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => RegularSchedule.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "내 정규 일정을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<DateTime>> getAvailableSpots({
    required String branchName,
    required String teacherID,
    required DateTime startDate,
  }) async {
    var response = await dio.post("/reservation/available", data: {
      "branchName": branchName,
      "teacherID": teacherID,
      "startDate": startDate.toIso8601String(),
    });
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => parseDateTime(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "예약 가능한 시간대를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Reservation>> getReservations({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    String? userID,
    required List<int> bookingStatus,
  }) async {
    var response = await dio.post(
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
      return List.generate(
        response.data.length,
        (index) => Reservation.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "예약 내역을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Change>> getChanges([String range = "both"]) async {
    var response = await dio.post("/reservation/changes", data: {
      "range": range,
    });
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => Change.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "변경 내역을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Term>> getCurrentTerm() async {
    var response = await dio.get("/term");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Term.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "현재 학기 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> makeUpReservation({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post("/reservation/user", data: {
      "teacherID": teacherID,
      "branchName": branchName,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "userID": userID,
    });
  }

  Future<void> cancelReservation(int id) async {
    await dio.patch("/reservation/user/cancel/$id");
  }

  Future<void> extendReservation(int id) async {
    await dio.patch("/reservation/user/extend/$id");
  }

  Future<void> checkIn(String branchCode) async {
    await dio.post("/check-in", data: {
      "branchCode": branchCode,
    });
  }
}

class NetworkException extends DioError {
  String message;
  RequestOptions options;
  Response? response;

  NetworkException({
    required this.message,
    required this.options,
    this.response,
  }) : super(
          requestOptions: options,
        );

  factory NetworkException._({
    required String message,
    required RequestOptions options,
    Response? response,
  }) {
    return NetworkException(
      message: message,
      options: options,
      response: response,
    );
  }

  @override
  String toString() {
    if (response != null) {
      if (response!.statusCode == 400) {
        return "잘못된 요청입니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 401) {
        return "인증이 필요합니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 403) {
        return "요청한 데이터에 대해 권한을 갖고 있지 않습니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 404) {
        return "요청한 데이터를 찾을 수 없습니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 405) {
        return "취소 가능 횟수를 초과하였습니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 409) {
        return "중복된 데이터가 존재합니다. 관리자에게 문의하세요.";
      } else if (response!.statusCode == 412) {
        return "해당 슬롯이 현재 닫힌 상태입니다. 관리자에게 문의하세요.";
      }
    }

    message += "\n${options.method}${options.path}";
    if (options.queryParameters.isNotEmpty) {
      message += "\n${options.queryParameters}";
    }
    if (options.data != null &&
        options.path != "/auth/refresh" &&
        options.path != "/auth/login") {
      message += "\n${options.data}";
    }

    return message;
  }
}
