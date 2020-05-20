import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quote_character/models/user.dart';
import 'package:quote_character/providers/preferences_provider.dart';

class RestProvider {
  final _prefs = PreferenceProvider();

  String _baseUrl = 'https://quote-character.herokuapp.com';
  Map<String, String> _headerJson = {
    'Content-Type': 'application/json',
  };

  Future<bool> registerUser(User user) async {
    String url = '$_baseUrl/user/register';
    http.Response resp = await http.post(
      url,
      headers: _headerJson,
      body: jsonEncode(user.toJsonRegister()),
    );
    if (resp.statusCode == 200) {
      print(resp.body);
      return true;
    } else
      return false;
  }

  Future<bool> loginUser(User user) async {
    String url = '$_baseUrl/user/login';
    http.Response resp = await http.post(
      url,
      headers: _headerJson,
      body: jsonEncode(user.toJsonLogin()),
    );
    if (resp.statusCode == 200) {
      print(resp.body);
      Map<String, dynamic> json = jsonDecode(resp.body);
      await _prefs.saveDataString(KeyList.TOKEN, json['token']);
      await _prefs.saveDataString(KeyList.USER_ID, json['user_id']);
      await _prefs.saveDataString(KeyList.USER_NAME, json['username']);
      return true;
    } else {
      return false;
    }
  }
}
