import 'package:flutter/material.dart';
import 'package:nitc_telehealth_application/FrontEnd/Login_Page.dart';
import 'package:nitc_telehealth_application/FrontEnd/Register_user_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo App',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[800],
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/registeruser': (context) => const RegisterUser(),
      },
    );
  }
}
