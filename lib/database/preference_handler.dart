import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _keyIsLogin = "isLogin";

  //create login
  static Future<void> setLogin(bool isLogin) async {
    await _prefs.setBool(_keyIsLogin, isLogin);
  }

  //get/read apakah sdh login atau blm
  static bool get isLogin {
    //jika _keyIsLogin null, return false
    return _prefs.getBool(_keyIsLogin) ?? false;
  }

  //delete login (logout)
  static Future<void> logOut() async {
    await _prefs.remove(_keyIsLogin);
  }
}
