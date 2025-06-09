import 'dart:convert';

import 'package:flutter_bilbil_app/http/request/base_request.dart';

//网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

//网络请求统一格式
class HiNetResponse<T> {
  T? data;
  BaseRequest? request;
  int? statusCode;
  String? statusMessage;
  dynamic extra;
  HiNetResponse(
      {this.data,
      this.request,
      this.extra,
      this.statusCode,
      this.statusMessage});
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
