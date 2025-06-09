import 'package:flutter_bilbil_app/http/core/net_adapter.dart';
import 'package:flutter_bilbil_app/http/request/base_request.dart';

//测试适配器，mock数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    return Future<HiNetResponse<T>>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 200);
    });
  }
}
