import 'package:flutter/material.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluation'),
      ),
      body: const Center(
        child: Text(
          'Evaluation Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
