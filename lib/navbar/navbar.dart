import 'package:flutter/material.dart';

import 'package:project/pages/home.dart';
import 'package:project/pages/calculator.dart';
import 'package:project/pages/nearme.dart';
import 'package:project/pages/evaluation.dart';
import 'package:project/pages/history.dart';



class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  int myCurrentIndex = 0;
  List page = const[
    HomePage(),
    EvaluationPage(),
    CalculatorPage(),
    HistoryPage(),
    NearMePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: myCurrentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        
        onTap: (index){
          setState(() {
            myCurrentIndex = index;
          });
        },
        
        items: const [ 
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),label: 'Evaluation'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined),label: 'Calculator'),
        BottomNavigationBarItem(icon: Icon(Icons.history),label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: 'NearMe'),
      ],),
      body: page[myCurrentIndex]
    );
  }
}