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

  Future<List<Quote>> getAllQuotes() async {
    String url = '$_baseUrl/quote';
    http.Response resp = await http.get(url, headers: _headerJson);
    if (resp.statusCode == 200) {
      print('Respuestaa');
      List<dynamic> json = jsonDecode(resp.body);
      return List<Quote>.from(
        json.map(
          (mapJson) => Quote.fromJson(mapJson),
        ),
      );
    } else {
      print('Fue un error');
      return [];
    }
  }

  Future<bool> registerUser(User user) async {
    String url = '$_baseUrl/user/register';

    http.Response resp = await http.post(
      url,
      headers: _headerJson,
      body: jsonEncode(user.toJsonRegister()),
    );
    if (resp.statusCode == 200) {
      print('request register');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loginUser(User user) async {
    String url = '$_baseUrl/user/login';

    http.Response resp = await http.post(
      url,
      headers: _headerJson,
      body: jsonEncode(user.toJsonLogin()),
    );
    if (resp.statusCode == 200) {
      print('request login');
      Map<String, dynamic> json = jsonDecode(resp.body);
      _prefs.saveDataString(KeyList.TOKEN, json['token']);
      _prefs.saveDataString(KeyList.USER_ID, json['user_id']);
      _prefs.saveDataString(KeyList.USER_NAME, json['username']);
      return true;
    } else {
      print('error peticion');
      print(resp.body);
      return false;
    }
  }

  Future<bool> createQuote(Quote quote) async {
    String url = '$_baseUrl/quote/createQuote';
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'token': await _prefs.getDataString(KeyList.TOKEN),
    };
    http.Response resp = await http.post(
      url,
      headers: _header,
      body: jsonEncode(quote.toJson()),
    );
    if (resp.statusCode == 200) {
      print('create quote');
      print(resp.body);
      return true;
    } else {
      print('create quote fail');
      print(resp.body);
      return false;
    }
  }

  Future<bool> deleteQuote(Quote quote) async {
    String url = '$_baseUrl/quote/deleteQuote/${quote.id}';
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'token': await _prefs.getDataString(KeyList.TOKEN),
    };
    http.Response resp = await http.delete(url, headers: _header);
    if (resp.statusCode == 200) {
      print('delete quote');
      print(resp.body);
      return true;
    } else {
      print('delete quote fail');
      print(resp.body);
      return false;
    }
  }

  Future<bool> updateQuote(Quote quote) async {
    quote.quote = 'Frase modificada desde el metodo';

    String url = '$_baseUrl/quote/updateQuote/${quote.id}';

    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'token': await _prefs.getDataString(KeyList.TOKEN),
    };

    http.Response resp = await http.put(
      url,
      headers: _header,
      body: jsonEncode(quote.toJson()),
    );

    if (resp.statusCode == 200) {
      print('update quote');
      print(resp.body);
      return true;
    } else {
      print('update quote fail');
      print(resp.body);
      return false;
    }
  }
}
