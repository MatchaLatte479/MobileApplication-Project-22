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
    CalculatorPage(),
    NearMePage(),
    HistoryPage(),
    EvaluationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: myCurrentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 90, 78, 66),
        selectedItemColor: Color.fromARGB(255, 253, 242, 210),
        unselectedItemColor: Color.fromARGB(255, 119, 104, 88),
        
        onTap: (index){
          setState(() {
            myCurrentIndex = index;
          });
        },
        
        items: const [ 
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper_outlined),label: 'Article'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined),label: 'Quest'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outlined),label: 'Profile'),
      ],),
      body: page[myCurrentIndex]
    );
  }
}