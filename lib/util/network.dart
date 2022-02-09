import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    dio.options.connectTimeout = 75 * 1000;
    dio.options.receiveTimeout = 40 * 1000;
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
          message = message is List<dynamic>
              ? message.join("\n")
              : message.toString();
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
          message: "아래 메시지와 함께 관리자에게 문의하세요!\nDioError: ${error.message}",
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
        extra: requestOptions.extra,
      ),
    );
  }

  Future<void> logout() async {
    try {
      if (await isLoggedIn()) {
        await dio.patch("/auth/log-out");
      }
    } finally {
      await storage.delete(key: "accessToken");
      await storage.delete(key: "refreshToken");
      dio.options.headers.remove("Authorization");
    }
  }

  Future<Profile> login(
      String userID, String userPassword, bool autoLogin) async {
    var response = await dio.post(
      "/auth/login",
      data: {
        "userID": userID,
        "userPassword": userPassword,
      },
      options: Options(
        extra: {
          "401": "아이디 또는 비밀번호가 올바르지 않습니다.",
          "404": "아이디 또는 비밀번호가 올바르지 않습니다.",
        },
      ),
    );
    if (response.statusCode == 201) {
      if (response.data["userType"] == 0) {
        if (autoLogin) {
          await storage.write(
              key: "accessToken", value: response.data["access_token"]);
          await storage.write(
              key: "refreshToken", value: response.data["refresh_token"]);
        }
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
    var response = await dio.get(
      "/auth/profile",
      options: Options(
        extra: {
          "404": "존재하지 않는 계정입니다. 앱을 다시 실행해주세요.",
        },
      ),
    );
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
      )..sort((a, b) {
          var primary = a.dow.compareTo(b.dow);
          return primary != 0 ? primary : a.startTime.compareTo(b.startTime);
        });
    }
    throw NetworkException._(
      message: "내 정기 스케줄을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  // TODO: check if it is affected by time zone

  /// Regardless of hour and minute, only the `date` of `startDate` matters.
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
      )..sort((a, b) => a.compareTo(b));
    }
    throw NetworkException._(
      message: "예약 가능한 시간대를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  /// Regardless of time zone of `startDate` and `endDate`,
  /// normalized datetime matters.
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
      )..sort((a, b) => a.startDate.compareTo(b.startDate));
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
      )..sort((a, b) {
          var primary = a.fromStartDate.compareTo(b.fromStartDate);
          return primary != 0
              ? primary
              : a.toStartDate == null || b.toStartDate == null
                  ? 0
                  : a.toStartDate!.compareTo(b.toStartDate!);
        });
    }
    throw NetworkException._(
      message: "변경 내역을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  /// Returns terms sorted in descending order by the number of `take`.
  ///
  /// If `take` is zero, it returns all terms.
  Future<List<Term>> getTerms(int take) async {
    var response = await dio.get("/term/$take");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Term.fromJson(response.data[index]),
      )..sort((a, b) => b.termStart.compareTo(a.termStart));
    }
    throw NetworkException._(
      message: "학기 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  // TODO: It works well 'yet' with normalized local datetime.
  //  makeUp -> _showReserve -> availableSpots -> parseDateTime
  Future<void> makeUp({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post(
      "/reservation/user",
      data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      },
      options: Options(
        extra: {
          "400": "잘못된 요청입니다. 다음의 경우에 해당합니다." +
              "\n1) 수업 시작 4시간 전부터는 보강을 예약할 수 없습니다." +
              "\n2) 정기 스케줄이 평일 16시 이전에 해당하는 수강생은 16시 이전의 수업만 예약할 수 있습니다.",
          "409": "해당 시간대에 기예약된 수업이 존재합니다.",
          "412": "조건을 충족하지 않은 요청입니다. 다음의 경우에 해당합니다." +
              "\n1) 해당 시간대가 현재 닫힌 상태입니다. 다른 시간대에 예약을 시도하세요." +
              "\n2) 보강 가능한 횟수가 부족합니다. 취소 내역을 확인하거나 관리자에게 문의하세요.",
        },
      ),
    );
  }

  Future<void> cancel(int id) async {
    await dio.patch(
      "/reservation/user/cancel/$id",
      options: Options(
        extra: {
          "400": "수업 시작 4시간 전부터는 수업을 취소할 수 없습니다.",
          "403": "현재 학기가 아닌 다른 학기의 수업은 취소할 수 없습니다.",
          "404": "해당 수업을 찾을 수 없습니다. 앱을 다시 실행해주세요.",
          "405": "취소 가능 횟수를 초과하였습니다. 취소 내역을 확인하거나 관리자에게 문의하세요.",
        },
      ),
    );
  }

  Future<void> extend(int id) async {
    await dio.patch(
      "/reservation/user/extend/$id",
      options: Options(
        extra: {
          "400": "수업 시작 4시간 전부터는 수업을 연장할 수 없습니다.",
          "404": "해당 수업을 찾을 수 없습니다. 앱을 다시 실행해주세요.",
          "405": "이미 취소된 수업입니다. 앱을 다시 실행해주세요.",
          "409": "해당 시간대에 기예약된 수업이 존재합니다.",
          "412": "연장 가능한 횟수가 부족합니다. 취소 내역을 확인하거나 관리자에게 문의하세요.",
        },
      ),
    );
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
  DioErrorType errorType;

  NetworkException({
    required this.message,
    required this.options,
    this.response,
    this.errorType = DioErrorType.other,
  }) : super(
          requestOptions: options,
          type: errorType,
        );

  factory NetworkException._({
    required String message,
    required RequestOptions options,
    Response? response,
    DioErrorType errorType = DioErrorType.other,
  }) {
    return NetworkException(
      message: message,
      options: options,
      response: response,
      errorType: errorType,
    );
  }

  @override
  String toString() {
    if (errorType == DioErrorType.connectTimeout ||
        errorType == DioErrorType.sendTimeout ||
        errorType == DioErrorType.receiveTimeout) {
      return "연결 시간이 초과했습니다. 다시 시도해주세요.";
    }

    if (response != null) {
      if (response!.requestOptions.extra[response!.statusCode.toString()] !=
          null) {
        return response!.requestOptions.extra[response!.statusCode.toString()];
      } else {
        if (response!.statusCode == 400) {
          message = "잘못된 요청입니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 401) {
          message = "인증이 필요합니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 403) {
          message = "요청한 데이터에 대해 권한을 갖고 있지 않습니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 404) {
          message = "요청한 데이터를 찾을 수 없습니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 405) {
          message = "승인되지 않은 행동입니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 409) {
          message = "중복된 데이터가 존재합니다. 관리자에게 문의하세요.\n" + message;
        } else if (response!.statusCode == 412) {
          message = "조건을 충족하지 않은 요청입니다. 관리자에게 문의하세요.\n" + message;
        } else {
          message += "\nStatus: ${response!.statusCode}";
        }
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
