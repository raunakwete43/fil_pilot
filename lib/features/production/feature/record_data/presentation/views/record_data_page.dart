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

  Map<String, List<String>> pipeData = {};
  Map<int, List<int>> shiftRecord = {};

  // Date picker state
  DateTime selectedDate = DateTime.now();

  String? selectedPipeClass;
  String? selectedPipeSize;

  int? selectedShift; // Selected shift number
  int? selectedRecord; // Selected record number

  @override
  void initState() {
    super.initState();
    _getPipeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    machineNumberController.dispose();
    shiftNumberController.dispose();
    recordNumberController.dispose();
    batchNumberController.dispose();
    pipeClassController.dispose();
    pipeSizeController.dispose();
    super.dispose();
  }

  void _getPipeData() async {
    final requestUrl = "$baseUrl/api/get_pipes";

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        responseBody.forEach((key, value) {
          if (value is List<dynamic>) {
            pipeData[key] = value.map((item) => item.toString()).toList();
          }
        });
      });

      setState(() {});
    }
  }

  void _getShiftInfo(String machineNo) async {
    final requestUrl = "$baseUrl/api/get_shift_record?machine_no=$machineNo";
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      setState(() {
        // Convert Map<String, dynamic> to Map<int, List<int>>
        shiftRecord = responseBody.map<int, List<int>>(
          (key, value) => MapEntry(
            int.parse(key), // Convert key to int
            List<int>.from(value), // Convert value to List<int>
          ),
        );

        print(shiftRecord);
      });
    } else {
      // Handle error
      print("Failed to load shift records");
    }
  }

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
        pipeSize.isEmpty ||
        pipeClass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    } else {
      String formattedDateString = DateFormat(
        'yyyy-MM-dd',
      ).format(selectedDate);
      DateTime formattedDate = DateFormat(
        'yyyy-mm-dd',
      ).parse(formattedDateString);
      // Prepare the request
      final metadataRequest = MetadataRequest(
        machineNo: machineNo,
        shiftNo: shiftNo,
        recordNo: recordNo,
        batchNo: batchNo,
        recordDate: formattedDate,
      );

      final Map<String, String> requestBody = {
        "pipe_class": pipeClass.toLowerCase(),
        "pipe_size": pipeSize.toLowerCase(),
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

      final pipeInfo = PipeInfoRequest(
        pipeSize: pipeSize,
        pipeClass: pipeClass,
      );

      await context.read<MetadataCubit>().savePipeInfo(pipeInfo);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataRecords1()),
      );

      _getPipeData();
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
                    onChanged: (p0) {
                      _getShiftInfo(p0);
                    },
                  ),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
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
                  CustomAutocompleteTextField(
                    label: "Pipe Class",
                    controller: pipeClassController,
                    options: pipeData.keys.toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedPipeClass = value.toLowerCase();
                        pipeClassController.text = value.toLowerCase();
                      });
                    },
                  ),
                  CustomAutocompleteTextField(
                    label: "Pipe Size",
                    controller: pipeSizeController,
                    options:
                        selectedPipeClass != null &&
                                pipeData[selectedPipeClass] != null
                            ? pipeData[selectedPipeClass]!
                            : [], // Provide an empty list if null
                    onSelected: (value) {
                      setState(() {
                        selectedPipeSize = value.toLowerCase();
                        pipeSizeController.text = value.toLowerCase();
                      });
                    },
                    enabled: true, // Enable only if Pipe Class is selected
                  ),
                  SizedBox(height: 8.0),
                  Text("Select Shift No:"),
                  DropdownButton<int>(
                    value: selectedShift,
                    isExpanded: true,
                    hint: Text("Choose Shift"),
                    items:
                        shiftRecord.keys.map((int shift) {
                          return DropdownMenuItem<int>(
                            value: shift,
                            child: Text("Shift $shift"),
                          );
                        }).toList(),
                    onChanged: (int? newShift) {
                      setState(() {
                        selectedShift = newShift;
                        selectedRecord = null; // Reset record selection
                        shiftNumberController.text =
                            newShift?.toString() ?? ""; // Update text field
                        recordNumberController
                            .clear(); // Clear record number when shift changes
                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  Text("Select Record No:"),
                  DropdownButton<int>(
                    value: selectedRecord,
                    isExpanded: true,
                    hint: Text("Choose Record"),
                    items:
                        (selectedShift != null &&
                                shiftRecord[selectedShift] != null)
                            ? shiftRecord[selectedShift]!.map((int record) {
                              return DropdownMenuItem<int>(
                                value: record,
                                child: Text("Record $record"),
                              );
                            }).toList()
                            : [],
                    onChanged: (int? newRecord) {
                      setState(() {
                        selectedRecord = newRecord;
                        recordNumberController.text =
                            newRecord?.toString() ?? ""; // Update text field
                      });
                    },
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
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // Full width button
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
