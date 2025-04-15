import 'package:fil_pilot/features/production/feature/record_data/presentation/views/record_data_page.dart';
import 'package:fil_pilot/features/production/feature/view_data/presentation/views/view_data.dart';
import 'package:flutter/material.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Sky blue color
        title: const Text(
          'Production',
          style: TextStyle(
            color: Colors.lightBlue, // Yellow text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'lib/common/icons/fil_logo.png', // Path to the logo
            width: 100, // Set width of the logo
            height: 40, // Set height of the logo
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Container(
        color: Colors.lightBlue, // Light blue background color
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center buttons vertically
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewData(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.yellow, // Yellow background color for the button
                  foregroundColor: Colors.lightBlue, // Light blue text color
                  minimumSize:
                      const Size(250, 60), // Increased width and height
                  textStyle:
                      const TextStyle(fontSize: 20), // Increased font size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text('View Data'),
              ),
              const SizedBox(height: 20), // Space between the two buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Record Data Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecordDataPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.yellow, // Yellow background color for the button
                  foregroundColor: Colors.lightBlue, // Light blue text color
                  minimumSize:
                      const Size(250, 60), // Increased width and height
                  textStyle:
                      const TextStyle(fontSize: 20), // Increased font size

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text('Record Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
