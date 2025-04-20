import 'package:flutter/material.dart';
import 'package:project/pages/home.dart';
import 'package:project/pages/evaluation.dart';
import 'package:project/pages/calculator.dart';
import 'package:project/pages/history.dart';
import 'package:project/pages/nearme.dart';
import 'package:project/model/user_model.dart';

class NavigationPage extends StatefulWidget {
  final User user;

  const NavigationPage({super.key, required this.user});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int myCurrentIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(user: widget.user),
      EvaluationPage(),
      CalculatorPage(),
      HistoryPage(),
      NearMePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the AppBar completely
      body: pages[myCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myCurrentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF5F5F5),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            myCurrentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Evaluation'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined), label: 'Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: 'NearMe'),
        ],
      ),
    );
  }
}
