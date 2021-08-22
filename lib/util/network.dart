import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:solviolin_admin/model/canceled.dart';
import 'package:solviolin_admin/model/change.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/profile.dart';
import 'package:solviolin_admin/model/regular_schedule.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/model/teacher.dart';
import 'package:solviolin_admin/model/teacher_info.dart';
import 'package:solviolin_admin/model/term.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/format.dart';

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
      if (response.data["userType"] != 0) {
        await storage.write(
            key: "accessToken", value: response.data["access_token"]);
        await storage.write(
            key: "refreshToken", value: response.data["refresh_token"]);
        return Profile.fromJson(response.data);
      } else {
        throw "수강생은 로그인할 수 없습니다.";
      }
    }
    throw "내 정보를 불러올 수 없습니다.";
  }

  Future<Profile> getProfile() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/auth/profile");
      if (response.statusCode == 200) {
        if (response.data["userType"] != 0) {
          return Profile.fromJson(response.data);
        } else {
          throw "수강생은 로그인할 수 없습니다.";
        }
      }
    }
    throw "내 정보를 불러올 수 없습니다.";
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
    if (await isLoggedIn()) {
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
  }

  Future<List<User>> getUsers({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get(
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
        return List<User>.generate(
          response.data.length,
          (index) => User.fromJson(response.data[index]),
        );
      }
    }
    throw "유저 목록을 불러올 수 없습니다.";
  }

  Future<List<dynamic>> getRawUsers({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get(
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
    }
    throw "유저 목록을 불러올 수 없습니다.";
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
    if (await isLoggedIn()) {
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
  }

  Future<void> registerTerm({
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/term", data: {
        "termStart": termStart.toIso8601String(),
        "termEnd": termEnd.toIso8601String(),
      });
    }
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
    throw "현재 학기 목록을 불러올 수 없습니다.";
  }

  Future<List<Term>> getTerms(int take) async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/term/$take");
      if (response.statusCode == 200) {
        return List<Term>.generate(
          response.data.length,
          (index) => Term.fromJson(response.data[index]),
        );
      }
    }
    throw "학기 목록을 불러올 수 없습니다.";
  }

  Future<void> registerTeacher({
    required String teacherID,
    required String teacherBranch,
    required int workDow,
    required Duration startTime,
    required Duration endTime,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/teacher", data: {
        "teacherID": teacherID,
        "teacherBranch": teacherBranch,
        "workDow": workDow,
        "startTime": timeToString(startTime),
        "endTime": timeToString(endTime),
      });
    }
  }

  Future<void> deleteTeacher(int id) async {
    if (await isLoggedIn()) {
      await dio.delete("/teacher/$id");
    }
  }

  Future<List<Teacher>> getTeachers({
    String? teacherID,
    String? branchName,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get(
        "/teacher/search",
        queryParameters: {
          "teacherID": teacherID,
          "branchName": branchName,
        }..removeWhere((key, value) => value == null),
      );
      if (response.statusCode == 200) {
        return List<Teacher>.generate(
          response.data.length,
          (index) => Teacher.fromJson(response.data[index]),
        );
      }
    }
    throw "강사 스케줄 목록을 불러올 수 없습니다.";
  }

  Future<List<TeacherInfo>> getTeacherInfos({
    String? branchName,
    int? workDow,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get(
        "/teacher/search/name",
        queryParameters: {
          "branchName": branchName,
          "workDow": workDow,
        }..removeWhere((key, value) => value == null),
      );
      if (response.statusCode == 200) {
        return List<TeacherInfo>.generate(
          response.data.length,
          (index) => TeacherInfo.fromJson(response.data[index]),
        );
      }
    }
    throw "강사 정보 목록을 불러올 수 없습니다.";
  }

  Future<List<Control>> getControls({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    int? status,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post(
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
        return List<Control>.generate(
          response.data.length,
          (index) => Control.fromJson(response.data[index]),
        );
      }
    }
    throw "컨트롤 정보를 불러올 수 없습니다.";
  }

  Future<void> registerControl({
    required String teacherID,
    required String branchName,
    required DateTime controlStart,
    required DateTime controlEnd,
    required int status,
    required int cancelInClose,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/control", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "controlStart": controlStart.toIso8601String(),
        "controlEnd": controlEnd.toIso8601String(),
        "status": status,
        "cancelInClose": cancelInClose,
      });
    }
  }

  Future<void> deleteControl(int id) async {
    if (await isLoggedIn()) {
      await dio.delete("/control/$id");
    }
  }

  Future<void> cancelReservation(int id) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/user/cancel/$id");
    }
  }

  Future<void> cancelReservationByAdmin(int id) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/admin/cancel/$id");
    }
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

  Future<void> makeUpReservationByAdmin({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/admin", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
    }
  }

  Future<void> reserveFreeCourse({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/free", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
    }
  }

  Future<void> extendReservation(int id) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/user/extend/$id");
    }
  }

  Future<void> extendReservationByAdmin({
    required int id,
    required int count,
  }) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/admin/extend/$id/$count");
    }
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

  Future<List<Change>> getChangesWithID(
    String userID, {
    String range = "both",
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/reservation/changes/$userID", data: {
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

  Future<List<Canceled>> getCanceledReservations(String teacherID) async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/reservation/canceled/$teacherID");
      if (response.statusCode == 200) {
        return List<Canceled>.generate(
          response.data.length,
          (index) => Canceled.fromJson(response.data[index]),
        );
      }
    }
    throw "취소 내역을 불러올 수 없습니다.";
  }

  Future<void> reserveRegularReservation({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/regular", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
    }
  }

  Future<void> updateEndDateAndDeleteLaterCourse(
    int id, {
    required DateTime endDate,
  }) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/regular/$id", data: {
        "endDate": endDate.toIso8601String(),
      });
    }
  }

  Future<void> extendAllCoursesOfBranch(String branch) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/regular/extend/$branch");
    }
  }

  Future<void> extendAllCoursesOfUser(String userID) async {
    if (await isLoggedIn()) {
      await dio.post("/reservation/regular/extend/user/$userID");
    }
  }

  Future<void> modifyTerm(
    int id, {
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    if (await isLoggedIn()) {
      await dio.patch("/reservation/term/$id", data: {
        "termStart": termStart,
        "termEnd": termEnd,
      });
    }
  }

  Future<List<RegularSchedule>> getRegularSchedulesByAdmin(
      String userID) async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/regular-schedule/$userID");
      if (response.statusCode == 200) {
        return List<RegularSchedule>.generate(
          response.data.length,
          (index) => RegularSchedule.fromJson(response.data[index]),
        );
      }
    }
    throw "해당 유저의 정규 예약 정보를 불러올 수 없습니다.";
  }

  Future<void> registerBranch(String branchName) async {
    if (await isLoggedIn()) {
      await dio.post("/branch", data: {
        "branchName": branchName,
      });
    }
  }

  Future<List<String>> getBranches() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/branch");
      if (response.statusCode == 200) {
        return List<String>.generate(
          response.data.length,
          (index) => response.data[index]["branchName"],
        );
      }
    }
    throw "지점 정보를 불러올 수 없습니다.";
  }

  Future<void> registerLedger({
    required String userID,
    required int amount,
    required int termID,
    required String branchName,
  }) async {
    if (await isLoggedIn()) {
      await dio.post("/ledger", data: {
        "userID": userID,
        "amount": amount,
        "termID": termID,
        "branchName": branchName,
      });
    }
  }

  Future<List<Ledger>> getLedgers({
    required String branchName,
    required int termID,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/ledger", queryParameters: {
        "branchName": branchName,
        "termID": termID,
        "userID": userID,
      });
      if (response.statusCode == 200) {
        return List<Ledger>.generate(
          response.data.length,
          (index) => Ledger.fromJson(response.data[index]),
        );
      }
    }
    throw "매출 정보를 불러올 수 없습니다.";
  }

  Future<String> getTotalLedger({
    required String branchName,
    required int termID,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/ledger/total", queryParameters: {
        "branchName": branchName,
        "termID": termID,
      });
      if (response.statusCode == 200) {
        // return response.data != "0"
        //     ? NumberFormat.simpleCurrency(
        //         locale: "ko_KR",
        //         name: "",
        //       ).format(response.data)
        //     : "0";
        return NumberFormat("#,###원").format(int.parse(response.data));
      }
    }
    throw "총 매출 정보를 불러올 수 없습니다.";
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
