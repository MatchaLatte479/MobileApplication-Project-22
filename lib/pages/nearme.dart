import 'package:flutter/material.dart';

class NearMePage extends StatelessWidget {
  const NearMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Near Me'),
      ),
      body: const Center(
        child: Text(
          'Near Me Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
