import 'package:fil_pilot/features/production/presentation/views/production.dart';
import 'package:flutter/material.dart';

class SubmitData extends StatelessWidget {
  const SubmitData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Submitted'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            // Push to ProductionScreen and clear the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ProductionScreen(),
              ),
              (route) => false, // Remove all routes
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Data is recorded successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

