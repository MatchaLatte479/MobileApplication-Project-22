import 'package:flutter/material.dart';
import 'package:project/navbar/navbar.dart';
// import 'pages/login.dart';
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
      home: NavigationPage(), 
    );
  }
}