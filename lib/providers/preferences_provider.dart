import 'package:shared_preferences/shared_preferences.dart';

enum KeyList { USER_ID, USER_NAME, TOKEN }

class PreferenceProvider {
  SharedPreferences _prefs;

  Future<bool> saveDataString(String key, String value) async {
    _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(key, value);
  }

  Future<String> getDataString(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }
}
