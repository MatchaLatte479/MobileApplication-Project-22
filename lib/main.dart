import 'package:flutter/material.dart';
import 'package:project/navbar/navbar.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F5),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blue,
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: const SlideRightTransitionsBuilder(),
            TargetPlatform.iOS: const SlideRightTransitionsBuilder(),
          },
        ),
      ),
      home: NavigationPage(),
    );
  }
}

class SlideRightTransitionsBuilder extends PageTransitionsBuilder {
  const SlideRightTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // ใช้ CurvedAnimation เพื่อให้ transition ลื่นและเร็วขึ้น
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // เริ่มจากขวา
        end: Offset.zero, // จบที่ตรงกลาง
      ).animate(curvedAnimation),
      child: child,
    );
  }
}
