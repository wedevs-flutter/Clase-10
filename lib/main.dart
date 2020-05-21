import 'package:flutter/material.dart';
import 'package:quote_character/pages/home_page.dart';
import 'package:quote_character/pages/login_page.dart';
import 'package:quote_character/pages/quote_page.dart';
import 'package:quote_character/pages/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'home': (context) => HomePage(),
        'quote': (context) => QuotePage(),
      },
    );
  }
}
