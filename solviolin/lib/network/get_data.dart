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
import 'package:solviolin/util/controller.dart';

class Client {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();
  DataController _controller = Get.find<DataController>();

  Client() {
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;
    dio.options.baseUrl = "http://3.36.254.21";

    // not to get breakpoints at dioError
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status! < 600;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (await isLoggedIn()) {
          options.headers["Authorization"] =
              "Bearer ${await storage.read(key: "accessToken")}";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          _controller.isComplete.add(true);
        } else {
          _controller.isComplete.add(false);
          if (response.statusCode == 400) {
            _controller.cacheMessage("not proper request body.");
            Get.defaultDialog(
              title: "정보를 불러올 수 없습니다.\n다시 확인해 주세요!",
            );
          } else if (response.statusCode == 401) {
            bool _containsAccess =
                await storage.containsKey(key: "accessToken");
            bool _containsRefresh =
                await storage.containsKey(key: "refreshToken");
            if (!_containsAccess && !_containsRefresh) {
              _controller.cacheMessage("아이디 또는 비밀번호가 일치하지 않습니다.");
            } else if (!_containsAccess && _containsRefresh) {
              _controller.cacheMessage("인증이 만료되었습니다. 자동으로 로그아웃 됩니다.");
              Get.offAllNamed("/login");
              logout();
            } else if (_containsAccess && _containsRefresh) {
              _controller.isAllComplete
                  .add(await _controller.checkComplete(true));
              refresh();
              retry(response.requestOptions);
              // response.statusCode = 200;
            } else {
              _controller
                  .cacheMessage("containsAccess && !containsRefresh => ??");
            }
          } else if (response.statusCode == 404) {
            _controller.cacheMessage("정보가 존재하지 않습니다.\n다시 확인해 주세요!");
          }
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        _controller.cacheMessage(error.message);
        return handler.next(error);
      },
    ));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
  }

  Future<dynamic> login(String userID, String userPassword) async {
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
    return null;
  }

  Future<bool> isLoggedIn() async {
    return await storage.containsKey(key: "accessToken");
  }

  Future<void> refresh() async {
    String? refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken != null) {
      await storage.delete(key: "accessToken");
      _controller.isComplete = [];
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
    Options options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> logout() async {
    await storage.deleteAll();
    dio.options.headers.remove("Authorization");
    _controller.isComplete = [];
  }

  Future<dynamic> getProfile() async {
    if (await isLoggedIn()) {
      Response response = await dio.get("/auth/profile");
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    }
    return null;
  }

  Future<List<RegularSchedule>> getRegularSchedules() async {
    List<RegularSchedule> regularSchedules = [];
    if (await isLoggedIn()) {
      Response response = await dio.get("/regular-schedule");
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          regularSchedules.add(RegularSchedule.fromJson(response.data[i]));
        }
      }
    }
    return regularSchedules;
  }

  Future<List<Teacher>> getTeachers(
      {String? teacherID, String? branchName}) async {
    List<Teacher> teachers = [];
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
        for (int i = 0; i < response.data.length; i++) {
          teachers.add(Teacher.fromJson(response.data[i]));
        }
      }
    }
    return teachers;
  }

  Future<List<Reservation>> getReservations({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    String? userID,
    required List<int> bookingStatus,
  }) async {
    List<Reservation> reservations = [];
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
        for (int i = 0; i < response.data.length; i++) {
          reservations.add(Reservation.fromJson(response.data[i]));
        }
      }
    }
    return reservations;
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
        _controller.cacheMessage("해당 시간에 이미 수업이 존재합니다. 창을 새로고침 해주세요.");
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
        _controller.cacheMessage("다른 수강생의 수업을 취소할 수 없습니다.");
      } else if (response.statusCode == 405) {
        _controller.cacheMessage("이번 학기에 더 이상 수업을 취소할 수 없습니다.");
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
        _controller.cacheMessage("해당 시간에 이미 수업이 존재합니다. 창을 새로고침 해주세요.");
      } else if (response.statusCode == 412) {
        _controller.cacheMessage("해당 시간에는 수업을 예약할 수 없습니다.");
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
        _controller.cacheMessage("다른 수강생의 수업을 연장할 수 없습니다.");
      } else if (response.statusCode == 409) {
        _controller.cacheMessage("해당 시간에 이미 수업이 존재합니다. 창을 새로고침 해주세요.");
      }
    }
  }

  Future<List<Term>> getTerms() async {
    List<Term> terms = [];
    if (await isLoggedIn()) {
      Response response = await dio.get("/term");
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          terms.add(Term.fromJson(response.data[i]));
        }
      }
    }
    return terms;
  }

  Future<List<Term>> getCurrentTerm() async {
    List<Term> currentTerms = [];
    if (await isLoggedIn()) {
      Response response = await dio.get("/term/cur");
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          currentTerms.add(Term.fromJson(response.data[i]));
        }
      }
    }
    return currentTerms;
  }

  Future<List<Control>> getControls(
      {String? teacherID, String? branchName}) async {
    List<Control> controls = [];
    if (await isLoggedIn()) {
      Map<String, dynamic> queries = {};
      if (teacherID != null) {
        queries["teacherID"] = teacherID;
      }
      if (branchName != null) {
        queries["branchName"] = branchName;
      }
      Response response = await dio.get("/control", queryParameters: queries);
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          controls.add(Control.fromJson(response.data[i]));
        }
      }
    }
    return controls;
  }

  Future<void> checkIn(String branchCode) async {
    if (await isLoggedIn()) {
      await dio.post("/check-in", data: {
        "branchCode": branchCode,
      });
    }
  }

  //

  Future<void> registerTeacher() async {
    if (await isLoggedIn()) {
      await dio.post("/teacher", data: {
        "teacherID": "teacher2",
        "teacherBranch": "잠실",
        "workDow": 3,
        "startTime": "10:00",
        "endTime": "16:30",
      });
    }
  }

  Future<void> updateUserInformation() async {
    if (await isLoggedIn()) {
      await dio.patch("/user/sleep1", data: {
        "userBranch": "잠실",
      });
    }
  }
}
