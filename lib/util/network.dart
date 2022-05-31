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
          errorType: error.type,
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

  Future<Profile> login({
    required String userID,
    required String userPassword,
    required bool autoLogin,
  }) async {
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
      if (response.data["userType"] != 0) {
        if (autoLogin) {
          await storage.write(
              key: "accessToken", value: response.data["access_token"]);
          await storage.write(
              key: "refreshToken", value: response.data["refresh_token"]);
        }
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

  Future<void> registerUser({
    required String userID,
    required String userPassword,
    required String userName,
    required String userPhone,
    required int userType,
    required String userBranch,
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
      },
      options: Options(
        extra: {
          "409": "중복된 아이디 또는 전화번호가 이미 등록되어 있습니다. 다시 확인해주세요.",
        },
      ),
    );
  }

  Future<List<User>> getUsers({
    String? branchName,
    String? userID,
    int? isPaid,
    int? userType,
    int? status,
    int? termID,
  }) async {
    var response = await dio.get(
      "/user",
      queryParameters: {
        "branchName": branchName,
        "userID": userID,
        "isPaid": isPaid,
        "userType": userType,
        "status": status,
        "termID": termID,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => User.fromJson(response.data[index]),
      )..sort((a, b) => a.userID.compareTo(b.userID));
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
    String? color,
  }) async {
    await dio.patch(
      "/user/$userID",
      data: {
        "userName": userName,
        "userPhone": userPhone,
        "userBranch": userBranch,
        "userCredit": userCredit,
        "status": status,
        "color": color,
      }..removeWhere((key, value) => value == null),
      options: Options(
        extra: {
          "400": "입력값이 없습니다. 다시 확인해주세요.",
          "409": "중복된 전화번호가 이미 등록되어 있습니다. 다시 확인해주세요.",
        },
      ),
    );
  }

  Future<void> resetPassword({
    required String userID,
    required String userPassword,
  }) async {
    await dio.patch("/user/admin/reset", data: {
      "userID": userID,
      "userPassword": userPassword,
    });
  }

  Future<void> terminateTeacher(String teacherID) async {
    await dio.patch(
      "/user/terminate/teacher",
      data: {
        "teacherID": teacherID,
        "endDate": DateTime.now().toIso8601String(),
      },
      options: Options(
        extra: {
          "404": "해당 강사를 찾을 수 없습니다. 다시 확인해주세요.",
        },
      ),
    );
  }

  Future<void> initializeCredit() async {
    await dio.patch("/user/initialize/credit");
  }

  Future<void> registerTerm({
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    await dio.post(
      "/term",
      data: {
        "termStart": termStart.toIso8601String(),
        "termEnd": termEnd.toIso8601String(),
      },
      options: Options(
        extra: {
          "409": "해당 기간에 학기가 기등록되어 있습니다.",
        },
      ),
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
      )..sort((a, b) {
          var primary = a.teacherID.compareTo(b.teacherID);
          var secondary = a.workDow.compareTo(b.workDow);
          return primary != 0
              ? primary
              : secondary != 0
                  ? secondary
                  : a.startTime.compareTo(b.startTime);
        });
    }
    throw NetworkException._(
      message: "강사 스케줄 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<TeacherInfo>> getTeacherInfos({
    String? branchName,
  }) async {
    var response = await dio.get(
      "/teacher/search/name",
      queryParameters: {
        "branchName": branchName,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => TeacherInfo.fromJson(response.data[index]),
      )..sort((a, b) => a.teacherID.compareTo(b.teacherID));
    }
    throw NetworkException._(
      message: "강사 정보 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<List<Control>> getControls({
    required String branchName,
    String? teacherID,
    DateTime? controlStart,
    DateTime? controlEnd,
    int? status,
  }) async {
    var response = await dio.post(
      "/control/search",
      data: {
        "branchName": branchName,
        "teacherID": teacherID,
        "controlStart": controlStart?.toIso8601String(),
        "controlEnd": controlEnd?.toIso8601String(),
        "status": status,
      }..removeWhere((key, value) => value == null),
    );
    if (response.statusCode == 201) {
      return List.generate(
        response.data.length,
        (index) => Control.fromJson(response.data[index]),
      )..sort((a, b) => b.controlStart.compareTo(a.controlStart));
    }
    throw NetworkException._(
      message: "오픈/클로즈 정보를 불러올 수 없습니다.",
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

  Future<void> cancelReservationByAdmin(
    int id, {
    required bool deductCredit,
  }) async {
    await dio.patch(
      "/reservation/admin/cancel/$id/${deductCredit ? 1 : 0}",
      options: Options(
        extra: {
          "404": "해당 수업을 찾을 수 없습니다. 재검색을 시도하세요.",
          "405": "취소 가능 횟수를 초과하였습니다. 취소 내역을 확인하세요.",
        },
      ),
    );
  }

  Future<void> makeUpReservationByAdmin({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post(
      "/reservation/admin",
      data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      },
      options: Options(
        extra: {
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 재검색을 시도하세요.",
          "412": "조건을 충족하지 않은 요청입니다. 다음의 경우에 해당합니다." +
              "\n1) 해당 시간대가 현재 닫힌 상태입니다. 다른 시간대에 예약을 시도하세요." +
              "\n2) 보강 가능한 횟수가 부족합니다. 취소 내역을 확인하세요." +
              "\n3) 입력값이 정기 스케줄의 데이터와 일치하지 않습니다. 정기 스케줄을 확인하세요.",
        },
      ),
    );
  }

  Future<void> reserveFreeCourse({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    await dio.post(
      "/reservation/free",
      data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      },
      options: Options(
        extra: {
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 재검색을 시도하세요.",
        },
      ),
    );
  }

  Future<void> extendReservationByAdmin(
    int id, {
    required bool deductCredit,
  }) async {
    await dio.patch(
      "/reservation/admin/extend/$id/${deductCredit ? 1 : 0}",
      options: Options(
        extra: {
          "400": "수업 시작 4시간 전부터는 수업을 연장할 수 없습니다.",
          "404": "해당 수업을 찾을 수 없습니다. 재검색을 시도하세요.",
          "405": "이미 취소된 수업입니다. 재검색을 시도하세요.",
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 재검색을 시도하세요.",
          "412": "연장 가능한 횟수가 부족합니다. 취소 내역을 확인하세요.",
        },
      ),
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
      )..sort((a, b) => a.startDate.compareTo(b.startDate));
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
      )..sort((a, b) => a.teacherID.compareTo(b.teacherID));
    }
    throw NetworkException._(
      message: "급여 목록을 불러올 수 없습니다.",
      options: response.requestOptions,
    );
  }

  Future<void> deleteReservation(int id) async {
    await dio.delete("/reservation", data: {
      "ids": [id],
    });
  }

  Future<List<Canceled>> getCanceledReservations(String teacherID) async {
    var response = await dio.get("/reservation/canceled/$teacherID");
    if (response.statusCode == 200) {
      return List.generate(
        response.data.length,
        (index) => Canceled.fromJson(response.data[index]),
      )..sort((a, b) => b.startDate.compareTo(a.startDate));
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
    await dio.post(
      "/reservation/regular",
      data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      },
      options: Options(
        extra: {
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 재검색을 시도하세요.",
          "412": "해당 시간대가 현재 닫힌 상태입니다. 다른 시간대에 예약을 시도하세요.",
        },
      ),
    );
  }

  Future<void> updateEndDateAndDeleteLaterCourse(
    int id, {
    required DateTime endDate,
  }) async {
    await dio.patch(
      "/reservation/regular/$id",
      data: {
        "endDate": endDate.toIso8601String(),
      },
      options: Options(
        extra: {
          "404": "해당 정기 스케줄을 찾을 수 없습니다. 정기 스케줄을 확인하세요.",
        },
      ),
    );
  }

  Future<void> extendAllCoursesOfBranch(String branch) async {
    await dio.post(
      "/reservation/regular/extend/$branch",
      options: Options(
        extra: {
          "404": "다음 학기가 등록되어 있지 않습니다.",
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 예약 슬롯을 확인하세요.",
        },
      ),
    );
  }

  Future<void> extendAllCoursesOfUser(String userID) async {
    await dio.post(
      "/reservation/regular/extend/user/$userID",
      options: Options(
        extra: {
          "404": "다음 학기가 등록되어 있지 않습니다.",
          "409": "해당 시간대에 기예약된 수업이 존재합니다. 예약 슬롯을 확인하세요.",
        },
      ),
    );
  }

  Future<void> modifyTerm(
    int id, {
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    await dio.patch(
      "/reservation/term/$id",
      data: {
        "termStart": termStart.toIso8601String(),
        "termEnd": termEnd.toIso8601String(),
      },
      options: Options(
        extra: {
          "400": "잘못된 요청입니다. 다음의 경우에 해당합니다." +
              "\n1) 다음 학기만 수정할 수 있습니다. 올바른 학기인지 확인하세요." +
              "\n2) 시작일이 종료일보다 클 수 없습니다. 올바르게 입력했는지 확인하세요.",
        },
      ),
    );
  }

  Future<void> deleteRegularSchedule(int id) async {
    await dio.delete(
      "/regular-schedule/$id",
      options: Options(
        extra: {
          "404": "해당 정기 스케줄을 찾을 수 없습니다. 정기 스케줄을 확인하세요.",
        },
      ),
    );
  }

  Future<List<RegularSchedule>> getRegularSchedulesByAdmin(
      String userID) async {
    var response = await dio.get(
      "/regular-schedule/$userID",
      options: Options(
        extra: {
          "404": "해당 정기 스케줄을 찾을 수 없습니다. 정기 스케줄을 확인하세요.",
        },
      ),
    );
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
      message: "해당 유저의 정기 스케줄을 불러올 수 없습니다.",
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
      )..sort((a, b) => a.compareTo(b));
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
      )..sort((a, b) {
          var primary = b.createdAt.compareTo(a.createdAt);
          return primary != 0 ? primary : b.id.compareTo(a.id);
        });
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
      )..sort((a, b) {
          var primary = b.paidAt.compareTo(a.paidAt);
          return primary != 0 ? primary : a.userID.compareTo(b.userID);
        });
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

  bool get isTimeout =>
      errorType == DioErrorType.connectTimeout ||
      errorType == DioErrorType.sendTimeout ||
      errorType == DioErrorType.receiveTimeout;

  @override
  String toString() {
    if (isTimeout) {
      return "연결 시간이 초과했습니다. 다시 시도해주세요.";
    }

    if (response != null) {
      var status = response!.statusCode;
      if (options.extra[status.toString()] != null) {
        return options.extra[status.toString()];
      } else {
        if (status == 400) {
          message = "잘못된 요청입니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 401) {
          message = "인증이 필요합니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 403) {
          message = "요청한 데이터에 대해 권한을 갖고 있지 않습니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 404) {
          message = "요청한 데이터를 찾을 수 없습니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 405) {
          message = "승인되지 않은 행동입니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 409) {
          message = "중복된 데이터가 존재합니다. 관리자에게 문의하세요.\n" + message;
        } else if (status == 412) {
          message = "조건을 충족하지 않은 요청입니다. 관리자에게 문의하세요.\n" + message;
        } else {
          message += "\nStatus: $status";
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
