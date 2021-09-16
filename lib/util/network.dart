import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:solviolin_admin/model/canceled.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/model/check_in.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/profile.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/salary.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/format.dart';

//TODO: add comments

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
        var accessT = await isLoggedIn(); //TODO: touch up implemented
        var refreshT = await storage.containsKey(key: "refreshToken");

        if (response.statusCode == 401 && accessT && refreshT) {
          try {
            await refresh();
            return handler.next(await retry(response.requestOptions));
          } on NetworkException catch (e) {
            return handler.reject(e);
          }
        } else if (response.statusCode == 401 && !accessT && refreshT) {
          Get.offAllNamed("/login");
          await logout();

          return handler.reject(NetworkException._(
            message: "인증이 만료되었습니다. 자동으로 로그아웃 됩니다.",
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
          ));
        }

        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.reject(NetworkException._(
          message: "DioError: ${error.message}",
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
    try {
      if (await isLoggedIn()) {
        await dio.patch("/auth/log-out");
      }
    } finally {
      await storage.deleteAll();
      dio.options.headers.remove("Authorization");
    }
  }

  Future<Profile> login(String userID, String userPassword) async {
    var response = await dio.post("/auth/login", data: {
      "userID": userID,
      "userPassword": userPassword,
    });
    if (response.statusCode == 201) {
      if (response.data["userType"] != 0) {
        await storage.write(
            key: "accessToken", value: response.data["access_token"]);
        await storage.write(
            key: "refreshToken", value: response.data["refresh_token"]);
        return Profile.fromJson(response.data);
      } else {
        throw NetworkException._(
          message: "수강생은 로그인할 수 없습니다.",
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
      if (response.data["userType"] != 0) {
        return Profile.fromJson(response.data);
      } else {
        throw NetworkException._(
          message: "수강생은 로그인할 수 없습니다.",
          options: response.requestOptions,
        );
      }
    }
    throw NetworkException._(
      message: "내 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> registerUser({
    required String userID,
    required String userPassword,
    required String userName,
    required String userPhone,
    required int userType,
    required String userBranch,
    String? token,
  }) async {
    await dio.post(
      "/user",
      data: {
        "userID": userID,
        "userPassword": userPassword,
        "userName": userName,
        "userPhone": userPhone,
        "userType": userType,
        "userBranch": userBranch,
        "token": token,
      }..removeWhere((key, value) => value == null),
    );
  }

  Future<List<User>> getUsers({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
  }) async {
    var response = await dio.get(
      "/user",
      queryParameters: {
        "branchName": branchName,
        "userID": userID,
        "isPaid": isPaid,
        "userType": userType,
        "status": status,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => User.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "유저 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<dynamic>> getJsonUsers({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
  }) async {
    var response = await dio.get(
      "/user",
      queryParameters: {
        "branchName": branchName,
        "userID": userID,
        "isPaid": isPaid,
        "userType": userType,
        "status": status,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return response.data;
    }
    throw NetworkException._(
      message: "유저 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> updateUserInformation(
    String userID, {
    String? userName,
    String? userPhone,
    String? userBranch,
    int? userCredit,
    int? status,
    String? token,
  }) async {
    await dio.patch(
      "/user/$userID",
      data: {
        "userName": userName,
        "userPhone": userPhone,
        "userBranch": userBranch,
        "userCredit": userCredit,
        "status": status,
        "token": token,
      }..removeWhere((key, value) => value == null),
    );
  }

  Future<void> registerTerm({
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    await dio.post("/term", data: {
      "termStart": termStart.toIso8601String(),
      "termEnd": termEnd.toIso8601String(),
    });
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
      message: "현재 학기 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Term>> getTerms(int take) async {
    var response = await dio.get("/term/$take");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Term.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "학기 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> registerTeacher({
    required String teacherID,
    required String teacherBranch,
    required int workDow,
    required Duration startTime,
    required Duration endTime,
  }) async {
    await dio.post("/teacher", data: {
      "teacherID": teacherID,
      "teacherBranch": teacherBranch,
      "workDow": workDow,
      "startTime": timeToString(startTime),
      "endTime": timeToString(endTime),
    });
  }

  Future<void> deleteTeacher(int id) async {
    await dio.delete("/teacher/$id");
  }

  Future<List<Teacher>> getTeachers({
    String? teacherID,
    String? branchName,
  }) async {
    var response = await dio.get(
      "/teacher/search",
      queryParameters: {
        "teacherID": teacherID,
        "branchName": branchName,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Teacher.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "강사 스케줄 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<TeacherInfo>> getTeacherInfos({
    String? branchName,
    int? workDow,
  }) async {
    var response = await dio.get(
      "/teacher/search/name",
      queryParameters: {
        "branchName": branchName,
        "workDow": workDow,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => TeacherInfo.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "강사 정보 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Control>> getControls({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    int? status,
  }) async {
    var response = await dio.post(
      "/control/search",
      data: {
        "branchName": branchName,
        "teacherID": teacherID,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "status": status,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => Control.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "컨트롤 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> registerControl({
    required String teacherID,
    required String branchName,
    required DateTime controlStart,
    required DateTime controlEnd,
    required int status,
    required int cancelInClose,
  }) async {
    await dio.post("/control", data: {
      "teacherID": teacherID,
      "branchName": branchName,
      "controlStart": controlStart.toIso8601String(),
      "controlEnd": controlEnd.toIso8601String(),
      "status": status,
      "cancelInClose": cancelInClose,
    });
  }

  Future<void> deleteControl(int id) async {
    await dio.delete("/control/$id");
  }

  Future<void> cancelReservation(int id) async {
    await dio.patch("/reservation/user/cancel/$id");
  }

  Future<void> cancelReservationByAdmin(int id) async {
    await dio.patch("/reservation/admin/cancel/$id");
  }

  Future<void> makeUpReservationByAdmin({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post("/reservation/admin", data: {
      "teacherID": teacherID,
      "branchName": branchName,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "userID": userID,
    });
  }

  Future<void> reserveFreeCourse({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post("/reservation/free", data: {
      "teacherID": teacherID,
      "branchName": branchName,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "userID": userID,
    });
  }

  Future<void> extendReservation(int id) async {
    await dio.patch("/reservation/user/extend/$id");
  }

  Future<void> extendReservationByAdmin(
    int id, {
    required int count,
  }) async {
    await dio.patch("/reservation/admin/extend/$id/$count");
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

  Future<List<Change>> getChangesWithID(
    String userID, {
    String range = "both",
  }) async {
    var response = await dio.post("/reservation/changes/$userID", data: {
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

  Future<List<Salary>> getSalaries({
    required String branchName,
    required int termID,
    required int dayTimeCost,
    required int nightTimeCost,
  }) async {
    var response = await dio.post("/reservation/salary", data: {
      "branchName": branchName,
      "termID": termID,
      "dayTimeCost": dayTimeCost,
      "nightTimeCost": nightTimeCost,
    });
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => Salary.fromList(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "급여 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Canceled>> getCanceledReservations(String teacherID) async {
    var response = await dio.get("/reservation/canceled/$teacherID");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Canceled.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "취소 내역을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> reserveRegularReservation({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post("/reservation/regular", data: {
      "teacherID": teacherID,
      "branchName": branchName,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "userID": userID,
    });
  }

  Future<void> updateEndDateAndDeleteLaterCourse(
    int id, {
    required DateTime endDate,
  }) async {
    await dio.patch("/reservation/regular/$id", data: {
      "endDate": endDate.toIso8601String(),
    });
  }

  Future<void> extendAllCoursesOfBranch(String branch) async {
    await dio.post("/reservation/regular/extend/$branch");
  }

  Future<void> extendAllCoursesOfUser(String userID) async {
    await dio.post("/reservation/regular/extend/user/$userID");
  }

  Future<void> modifyTerm(
    int id, {
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    await dio.patch("/reservation/term/$id", data: {
      "termStart": termStart.toIso8601String(),
      "termEnd": termEnd.toIso8601String(),
    });
  }

  Future<List<RegularSchedule>> getRegularSchedulesByAdmin(
      String userID) async {
    var response = await dio.get("/regular-schedule/$userID");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => RegularSchedule.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "해당 유저의 정규 예약 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> registerBranch(String branchName) async {
    await dio.post("/branch", data: {
      "branchName": branchName,
    });
  }

  Future<List<String>> getBranches() async {
    var response = await dio.get("/branch");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => response.data[index]["branchName"],
      );
    }
    throw NetworkException._(
      message: "지점 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> checkIn(String branchCode) async {
    await dio.post("/check-in", data: {
      "branchCode": branchCode,
    });
  }

  Future<List<CheckIn>> getCheckInHistories({
    required String branchName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var response = await dio.post(
      "/check-in/search",
      data: {
        "branchName": branchName,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => CheckIn.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "체크인 이력을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> registerLedger({
    required String userID,
    required int amount,
    required int termID,
    required String branchName,
  }) async {
    await dio.post("/ledger", data: {
      "userID": userID,
      "amount": amount,
      "termID": termID,
      "branchName": branchName,
    });
  }

  Future<List<Ledger>> getLedgers({
    String? branchName,
    int? termID,
    String? userID,
  }) async {
    var response = await dio.get(
      "/ledger",
      queryParameters: {
        "branchName": branchName,
        "termID": termID,
        "userID": userID,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Ledger.fromJson(response.data[index]),
      );
    }
    throw NetworkException._(
      message: "매출 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> deleteLedger(int id) async {
    await dio.delete("/ledger/$id");
  }

  Future<String> getTotalLedger({
    required String branchName,
    required int termID,
  }) async {
    var response = await dio.get("/ledger/total", queryParameters: {
      "branchName": branchName,
      "termID": termID,
    });
    if (response.statusCode == 200) {
      var total = response.data;
      if (total is String) {
        total = num.parse(total);
      }

      return NumberFormat("#,###원").format(total);
    }
    throw NetworkException._(
      message: "총 매출 정보를 불러올 수 없습니다.",
      options: response.requestOptions,
    );
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
  String toString() {
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
