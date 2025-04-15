import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/views/last_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataRecords3 extends StatefulWidget {
  const DataRecords3({super.key});

  static List<String> labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  static const List<String> _labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  State<DataRecords3> createState() => _DataRecords3State();
}

class _DataRecords3State extends State<DataRecords3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    8,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  static const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Wall Thickness / Eccentricity Setting',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.lightBlue,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Circle with 8 points
                CustomPaint(
                  size: const Size(200, 200),
                  painter: CircleWithPointsPainter(),
                ),
                const SizedBox(height: 20),
                // Form to fill numerical values
                Form(
                  key: _formKey,
                  child: Column(
                    children: List.generate(8, (index) {
                      final label = DataRecords3._labels[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text('Point $label:', style: boldStyle),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: _controllers[index],
                                onChanged: (value) {
                                  setState(() {
                                    final label = DataRecords3._labels[index];
                                    DataRecords3.labels[index] =
                                        value.isEmpty
                                            ? label // Reset to original
                                            : "$label $value"; // Append value
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Value',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    // Validate the form
                    if (_formKey.currentState?.validate() ?? false) {
                      // Process the input values
                      List<String> values =
                          _controllers
                              .map((controller) => controller.text)
                              .toList();

                      Map<String, List<String>> walldata = {"values": values};
                      context.read<DataRecordsCubit>().saveWallData(walldata);

                      // Navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LastData()),
                      );
                    } else {
                      // Show a warning message if validation fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all fields with valid numbers.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.lightBlue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleWithPointsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw the circle
    canvas.drawCircle(center, radius, paint);

    // Draw the points and labels
    for (int i = 0; i < 8; i++) {
      final angle = 2 * pi * i / 8;
      final x = center.dx + radius * 0.8 * cos(angle);
      final y = center.dy + radius * 0.8 * sin(angle);
      final point = Offset(x, y);

      // Draw the point
      canvas.drawCircle(point, 4, Paint()..color = Colors.black);

      // Draw the label outside the circle
      final labelX = center.dx + radius * 1.2 * cos(angle);
      final labelY = center.dy + radius * 1.2 * sin(angle);
      final labelPoint = Offset(labelX, labelY);

      final textPainter = TextPainter(
        text: TextSpan(
          text: DataRecords3.labels[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Arial',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        labelPoint - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
