import 'package:flutter_bilbil_app/http/core/dio_adapter.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
//import 'package:flutter_bilbil_app/http/core/mock_adapter.dart';
import 'package:flutter_bilbil_app/http/core/net_adapter.dart';
import 'package:flutter_bilbil_app/http/request/base_request.dart';

import 'hi_interceptor.dart';

class HiNet {
  HiNet._();
  HiErrorInterceptor? _hiErrorInterceptor;
  static HiNet? _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //其他异常
      error = e;
      printLog(error);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        return NeedLogin();
      case 403:
        return NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) {
    printLog('url:${request.url()}');

    ///使用mock发送请求
    ///HiNetAdapter adapter = MockAdapter();
    ///使用dio发送请求
    HiNetAdapter adapter = DioAdapter();

    return adapter.send(request);
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    this._hiErrorInterceptor = interceptor;
  }

  void printLog(log) {
    print("hi_net:{${log.toString()}}");
  }
}
