import 'base_request.dart';

//获取通知列表
class NoticeRequest extends BaseRequest {
  @override
  String path() {
    return "uapi/notice";
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }
  
}