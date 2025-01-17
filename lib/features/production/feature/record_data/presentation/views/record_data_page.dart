import 'dart:convert';

import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/views/data_records1.dart';
import 'package:fil_pilot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'custom_text_input.dart';
import 'package:http/http.dart' as http;

class RecordDataPage extends StatefulWidget {
  const RecordDataPage({super.key});

  @override
  State<RecordDataPage> createState() => _RecordDataPageState();
}

class _RecordDataPageState extends State<RecordDataPage> {
  // Controllers for text input
  final TextEditingController machineNumberController = TextEditingController();
  final TextEditingController shiftNumberController = TextEditingController();
  final TextEditingController recordNumberController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController pipeClassController = TextEditingController();
  final TextEditingController pipeSizeController = TextEditingController();

  // Date picker state
  DateTime selectedDate = DateTime.now();

  // Method to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Method to validate fields and handle the Next button
  void _handleNext(BuildContext context) async {
    // Collect data from inputs
    final machineNo = machineNumberController.text;
    final shiftNo = int.tryParse(shiftNumberController.text) ?? 0;
    final recordNo = int.tryParse(recordNumberController.text) ?? 0;
    final batchNo = batchNumberController.text;
    final pipeClass = pipeClassController.text;
    final pipeSize = pipeSizeController.text;

    // Validate inputs (you can add more validations if necessary)
    if (machineNo.isEmpty ||
        shiftNo == 0 ||
        recordNo == 0 ||
        batchNo == 0 ||
        pipeSize.isEmpty ||
        pipeClass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    } else {
      String formattedDateString =
          DateFormat('yyyy-MM-dd').format(selectedDate);
      DateTime formattedDate =
          DateFormat('yyyy-mm-dd').parse(formattedDateString);
      // Prepare the request
      final metadataRequest = MetadataRequest(
        machineNo: machineNo,
        shiftNo: shiftNo,
        recordNo: recordNo,
        batchNo: batchNo,
        recordDate: formattedDate,
      );

      final Map<String, String> requestBody = {
        "pipe_class": pipeClass,
        "pipe_size": pipeSize
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      final response = await http.post(
        Uri.parse("$baseUrl/api/insert_pipe"),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Pipe Saved successfully");
      }

      // Call the cubit to insert metadata
      await context.read<MetadataCubit>().saveMetadata1(metadataRequest);

      final pipeInfo =
          PipeInfoRequest(pipeSize: pipeSize, pipeClass: pipeClass);

      await context.read<MetadataCubit>().savePipeInfo(pipeInfo);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataRecords1()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Record Data',
          style: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'lib/common/icons/fil_logo.png',
            width: 100,
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Machine Number',
                    controller: machineNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', // Always display the current date
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: 'Shift Number',
                    controller: shiftNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: 'Record Number',
                    controller: recordNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: "Pipe Class",
                    controller: pipeClassController,
                  ),
                  CustomTextField(
                    label: "Pipe Size",
                    controller: pipeSizeController,
                  ),
                  const SizedBox(height: 100), // Add spacing if needed
                ],
              ),
            ),
          ),
          // Button at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                onPressed: () => _handleNext(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.lightBlue,
                  minimumSize:
                      const Size(double.infinity, 50), // Full width button
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
