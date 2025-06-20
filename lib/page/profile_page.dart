import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
import 'package:flutter_bilbil_app/http/dao/profile_dao.dart';
import 'package:flutter_bilbil_app/model/profile_mo.dart';
import 'package:flutter_bilbil_app/util/toast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("我的"),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
