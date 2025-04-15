import 'package:flutter/material.dart';

class QualityScreen extends StatelessWidget {
  const QualityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Coming Soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
