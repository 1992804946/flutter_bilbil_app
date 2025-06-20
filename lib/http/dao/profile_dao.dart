import 'package:flutter_bilbil_app/http/core/hi_net.dart';
import 'package:flutter_bilbil_app/http/request/profile_request.dart';
import 'package:flutter_bilbil_app/model/profile_mo.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return ProfileMo.fromJson(result['data']);
  }
}
