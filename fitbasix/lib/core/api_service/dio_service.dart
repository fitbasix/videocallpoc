import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/log_in/controller/login_controller.dart';
import '../../feature/log_in/view/login_screen.dart';
import '../constants/image_path.dart';

class DioUtil {
  Dio? _instance;
//method for getting dio instance
  Dio? getInstance() {
    if (_instance == null) {
      _instance = createDioInstance();
    }
    return _instance;
  }

  Dio createDioInstance() {
    var dio = Dio();

    // adding interceptor
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options); //modify your request
    }, onResponse: (response, handler) {
      // ignore: unnecessary_null_comparison
      if (response != null) {
        return handler.next(response);
      } else {
        return null;
      }
    }, onError: (DioError e, handler) async {
      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          dio.interceptors.requestLock.lock();
          dio.interceptors.responseLock.lock();
          RequestOptions requestOptions = e.requestOptions;
          await LogInService.updateToken();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var accessToken = prefs.getString('AccessToken').toString();
          final opts = new Options(method: requestOptions.method);
          dio.options.headers["language"] = "1";
          dio.options.headers["Accept"] = "*/*";
          dio.options.headers['Authorization'] = accessToken;
          dio.interceptors.requestLock.unlock();
          dio.interceptors.responseLock.unlock();
          final response = await dio.request(requestOptions.path,
              options: opts,
              cancelToken: requestOptions.cancelToken,
              onReceiveProgress: requestOptions.onReceiveProgress,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters);
          // ignore: unnecessary_null_comparison
          if (response != null) {
            handler.resolve(response);
          } else {
            return null;
          }
        } else {
          if (e.response!.statusCode == 444) {
            InitializeQuickBlox().logOutUserSession();
            final LoginController _controller = Get.put(LoginController());
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            await _controller.googleSignout();
            navigator!.pushAndRemoveUntil<void>(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => LoginScreen()),
              ModalRoute.withName('/'),
            );
            Get.deleteAll();
          }
          if (e.response!.statusCode == 401 || e.response!.statusCode == 500) {
            final responseData = jsonDecode(e.response.toString());
            // print(e.requestOptions.path);
            final SnackBar snackBar =
                SnackBar(content: Text(responseData["response"]["message"]));
            snackbarKey.currentState?.showSnackBar(snackBar);
          }
          handler.next(e);
        }
      }
    }));
    return dio;
  }
}
