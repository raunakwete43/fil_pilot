import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
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
