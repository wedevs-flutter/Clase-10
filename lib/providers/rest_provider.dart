import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quote_character/models/quote.dart';

class RestProvider {
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
}
