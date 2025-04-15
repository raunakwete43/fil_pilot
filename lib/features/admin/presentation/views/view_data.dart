import 'dart:convert';

import 'package:fil_pilot/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final TextEditingController _recordNoController = TextEditingController();
  final TextEditingController _shiftNoController = TextEditingController();
  final TextEditingController _machineNoController = TextEditingController();

  Future<void> _downloadFile() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final String date = _dateController.text;
        final int recordNo = int.parse(_recordNoController.text);
        final int shiftNo = int.parse(_shiftNoController.text);
        final machineNo = _machineNoController.text.trim();

        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        };

        final Map<String, dynamic> requestBody = {
          "machine_no": machineNo,
          "shift_no": shiftNo,
          "record_no": recordNo,
          "record_date": date,
        };

        final response = await http.post(
          Uri.parse("$baseUrl/api/get_daily_data"),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);

          // Extract filename from Content-Disposition header
          String filename = "$date-$machineNo-$shiftNo-$recordNo.xlsx";

          // Get the downloads directory
          String? downloadsDir = await FilePicker.platform.getDirectoryPath();

          if (downloadsDir != null) {
            String savePath = '$downloadsDir/$filename';
            File file = File(savePath);
            await file.writeAsBytes(response.bodyBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File saved successfully to $savePath')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to retrieve save directory.')),
            );
          }
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download file.')),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
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
                        _dateController.text.isEmpty
                            ? 'Date (YYYY-MM-DD)'
                            : _dateController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: _dateController.text.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _machineNoController,
                  decoration: InputDecoration(
                    labelText: "Machine No",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter machine number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid machine number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _shiftNoController,
                  decoration: InputDecoration(
                    labelText: "Shift No",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Shift number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid shift number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _recordNoController,
                  decoration: InputDecoration(
                    labelText: "Record No",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter record number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid record number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _downloadFile,
                child: Text('Download File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

