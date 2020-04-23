import 'package:flutter/material.dart';
import 'package:flutter_gerente_loja/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerente Loja',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent
      ),
      home: LoginScreen(),
    );
  }

}