import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quote_character/models/quote.dart';
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

  Future<List<Quote>> getAllQuotes() async {
    String url = '$_baseUrl/quote';
    http.Response resp = await http.get(url, headers: _headerJson);
    if (resp.statusCode == 200) {
      List<dynamic> json = jsonDecode(resp.body);
      List<Quote> list = List<Quote>.from(json.map((e) => Quote.fromJson(e)));
      print(list.length);
      return list;
    } else {
      return [];
    }
  }

  Future<bool> createNewQuote(Quote quote) async {
    String url = '$_baseUrl/quote/createQuote';
    String userToken = await _prefs.getDataString(KeyList.TOKEN);
    String userName = await _prefs.getDataString(KeyList.USER_NAME);
    String userId = await _prefs.getDataString(KeyList.USER_ID);

    quote.author = userName;
    quote.authorId = userId;

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'token': userToken,
    };

    http.Response resp = await http.post(
      url,
      headers: header,
      body: jsonEncode(quote.toJson()),
    );

    if (resp.statusCode == 200) {
      print(resp.body);
      return true;
    } else
      return false;
  }

  Future<bool> updateQuote(Quote quote) async {
    String url = '$_baseUrl/quote/updateQuote/${quote.id}';
    String userToken = await _prefs.getDataString(KeyList.TOKEN);
    String userName = await _prefs.getDataString(KeyList.USER_NAME);
    String userId = await _prefs.getDataString(KeyList.USER_ID);

    quote.author = userName;
    quote.authorId = userId;

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'token': userToken,
    };

    http.Response resp = await http.put(
      url,
      headers: header,
      body: jsonEncode(quote.toJson()),
    );

    if (resp.statusCode == 200) {
      print(resp.body);
      return true;
    } else
      return false;
  }
}
