import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:solviolin/model/control.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/model/term.dart';
import 'package:solviolin/model/user.dart';

class Client {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  Client() {
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = "http://3.36.254.21";

    // not to get breakpoints at error
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status! < 600;

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
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
        if (response.statusCode == 400) {
          handler.next(response);
          throw "정보가 올바르지 않습니다.\n다시 확인해 주세요!";
        } else if (response.statusCode == 401) {
          if (!containsAccess && !containsRefresh) {
            handler.next(response);
            throw "아이디 또는 비밀번호가 일치하지 않습니다.";
          } else if (!containsAccess && containsRefresh) {
            Get.offAllNamed("/login");
            await logout();
            handler.next(response);
            throw "인증이 만료되었습니다.\n자동으로 로그아웃 됩니다.";
          } else if (containsAccess && containsRefresh) {
            await refresh();
            await retry(response.requestOptions);
          }
        } else if (response.statusCode == 404) {
          handler.next(response);
          throw "정보를 불러올 수 없습니다.\n다시 확인해 주세요!";
        }

        return handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
        throw error.message;
      },
    ));
  }

  Future<User> login(String userID, String userPassword) async {
    Response response = await dio.post("/auth/login", data: {
      "userID": userID,
      "userPassword": userPassword,
    });
    if (response.statusCode == 201) {
      await storage.write(
          key: "accessToken", value: response.data["access_token"]);
      await storage.write(
          key: "refreshToken", value: response.data["refresh_token"]);
      return User.fromJson(response.data);
    }
    throw "내 정보를 불러올 수 없습니다.";
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
    await storage.deleteAll();
    dio.options.headers.remove("Authorization");
  }

  Future<User> getProfile() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/auth/profile");
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
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

  Future<List<Teacher>> getTeachers(
      {String? teacherID, String? branchName}) async {
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
      if (response.statusCode == 200) {
        return List<Teacher>.generate(
          response.data.length,
          (index) => Teacher.fromJson(response.data[index]),
        );
      }
    }
    throw "내 선생님 정보를 불러올 수 없습니다.";
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
      Response response = await dio.post("/reservation/search", data: {
        "branchName": branchName,
        "teacherID": teacherID,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "userID": userID,
        "bookingStatus": bookingStatus,
      });
      if (response.statusCode == 201) {
        return List<Reservation>.generate(
          response.data.length,
          (index) => Reservation.fromJson(response.data[index]),
        );
      }
    }
    throw "예약 목록을 불러올 수 없습니다.";
  }

  Future<List<DateTime>> getAvailable({
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
          (index) => response.data[index],
        );
      }
    }
    throw "예약 목록을 불러올 수 없습니다.";
  }

  Future<void> reserveRegularReservation({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/reservation/regular", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
      if (response.statusCode == 409) {
        throw "해당 시간에 이미 수업이 존재합니다.\n창을 새로고침 해주세요.";
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw "정규 예약에 실패했습니다.";
      }
    }
  }

  Future<void> cancelReservation(String id) async {
    if (await isLoggedIn()) {
      Response response =
          await dio.patch("/reservation/user/cancel/$id", data: {
        "id": id,
      });
      if (response.statusCode == 403) {
        throw "다른 수강생의 수업을 취소할 수 없습니다.";
      } else if (response.statusCode == 405) {
        throw "이번 학기에 더 이상 수업을 취소할 수 없습니다.";
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw "예약 취소에 실패했습니다.";
      }
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
      Response response = await dio.post("/reservation/user", data: {
        "teacherID": teacherID,
        "branchName": branchName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "userID": userID,
      });
      if (response.statusCode == 409) {
        throw "해당 시간에 이미 수업이 존재합니다.\n창을 새로고침 해주세요.";
      } else if (response.statusCode == 412) {
        throw "해당 시간에는 수업을 예약할 수 없습니다.";
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw "보강 예약에 실패했습니다.";
      }
    }
  }

  Future<void> extendReservation(String id) async {
    if (await isLoggedIn()) {
      Response response =
          await dio.patch("/reservation/user/extend/$id", data: {
        "id": id,
      });
      if (response.statusCode == 403) {
        throw "다른 수강생의 수업을 연장할 수 없습니다.";
      } else if (response.statusCode == 409) {
        throw "해당 시간에 이미 수업이 존재합니다.\n창을 새로고침 해주세요.";
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw "수업 연장에 실패했습니다.";
      }
    }
  }

  Future<List<Term>> getTerms() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/term");
      if (response.statusCode == 200) {
        return List<Term>.generate(
          response.data.length,
          (index) => Term.fromJson(response.data[index]),
        );
      }
    }
    throw "학기 정보를 불러올 수 없습니다.";
  }

  Future<List<Term>> getCurrentTerms() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/term/cur");
      if (response.statusCode == 200) {
        return List<Term>.generate(
          response.data.length,
          (index) => Term.fromJson(response.data[index]),
        );
      }
    }
    throw "현재 학기 정보를 불러올 수 없습니다.";
  }

  Future<List<Control>> getControls({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    int? status,
  }) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/control/search", data: {
        "branchName": branchName,
        "teacherID": teacherID,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "status": status,
      });
      if (response.statusCode == 201) {
        return List<Control>.generate(
          response.data.length,
          (index) => Control.fromJson(response.data[index]),
        );
      }
    }
    return [];
  }

  Future<void> checkIn(String branchCode) async {
    if (await isLoggedIn()) {
      Response response = await dio.post("/check-in", data: {
        "branchCode": branchCode,
      });
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw "QR 코드 인증에 실패했습니다.";
      }
    }
  }
}
