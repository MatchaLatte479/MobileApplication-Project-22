import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solar Cell Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), 
      routes: {
        '/calculator': (context) => CalculatorScreen(),
      },
    );
  }
}