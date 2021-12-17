import 'package:dio/dio.dart';

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
        //on success it is getting called here
        return handler.next(response);
      } else {
        return null;
      }
    }, onError: (DioError e, handler) async {
      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          //catch the 401 here
          dio.interceptors.requestLock.lock();
          dio.interceptors.responseLock.lock();
          RequestOptions requestOptions = e.requestOptions;
          final opts = new Options(method: requestOptions.method);
          // dio.options.headers["Authorization"] = "Bearer " + accessToken;
          // dio.options.headers["Accept"] = "*/*";
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
          handler.next(e);
        }
      }
    }));
    return dio;
  }
}
