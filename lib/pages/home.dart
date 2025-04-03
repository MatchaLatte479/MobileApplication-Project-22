import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); // Make the constructor const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'), // Make Text const
      ),
      body: const Center(
        // Make Center const
        child: Text(
          'Home Page',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold), // Make TextStyle const
        ),
      ),
    );
  }
}
