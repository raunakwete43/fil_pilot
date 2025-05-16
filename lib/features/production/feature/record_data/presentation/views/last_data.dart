import 'dart:convert';

import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_cubit.dart';
import 'package:fil_pilot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'submit_page.dart'; // Import the SubmitData page

class LastData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Data Entry'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LastDataForm(),
      ),
    );
  }
}

class LastDataForm extends StatefulWidget {
  @override
  _LastDataFormState createState() => _LastDataFormState();
}

class _LastDataFormState extends State<LastDataForm> {
  final TextEditingController _lineEngineerController = TextEditingController();
  final TextEditingController _shiftEngineerController =
      TextEditingController();
  final TextEditingController _batchNoController = TextEditingController();
  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _lineEngineerController.dispose();
    _shiftEngineerController.dispose();
    _batchNoController.dispose();
    super.dispose();
  }

  void _submitData() async {
    final String lineEngineer = _lineEngineerController.text;
    final String shiftEngineer = _shiftEngineerController.text;
    final String batchNo = _batchNoController.text;

    final metadata = context.read<MetadataCubit>().metadataSaved;
    final pipeInfo = context.read<MetadataCubit>().pipeInfoRequest;

    final metadataRequest = MetadataRequest(
      machineNo: metadata.machineNo,
      shiftNo: metadata.shiftNo,
      recordNo: metadata.recordNo,
      batchNo: batchNo,
      lineEngineer: lineEngineer,
      shiftIncharge: shiftEngineer,
      recordDate: metadata.recordDate,
    );
    await context.read<MetadataCubit>().saveMetadata1(metadataRequest);

    await context.read<MetadataCubit>().saveMetadata2(pipeInfo);

    final metadata1 = context.read<MetadataCubit>().metadataSaved;

    print(metadata1.toJson().toString());

    await context.read<MetadataCubit>().insertMetadata(metadata1);

    final MetadataId = context.read<MetadataCubit>().metadataId;

    try {
      // save first page records
      final bodyData = context.read<DataRecordsCubit>().getBodyData;
      //  Create the request URL
      String url = '$baseUrl/api/insert_records?metadata_id=$MetadataId';

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      String body = jsonEncode(bodyData);

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      // save second page records
      final socketData = context.read<DataRecordsCubit>().getSocketData;
      //  Create the request URL
      String url = '$baseUrl/api/socket_records?metadata_id=$MetadataId';

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      String body = jsonEncode(socketData);

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      // save details page records
      final downtimeData = context.read<DataRecordsCubit>().getDownTimeData;
      //  Create the request URL
      String url = '$baseUrl/api/downtime_details?metadata_id=$MetadataId';

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      String body = jsonEncode(downtimeData);

      print(body.toString());

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      // save details page records
      final wastageData = context.read<DataRecordsCubit>().getWastageData;
      //  Create the request URL
      String url = '$baseUrl/api/wastage_details?metadata_id=$MetadataId';

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      String body = jsonEncode(wastageData);

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      // save values page records
      final getWallThicknessData =
          context.read<DataRecordsCubit>().getWallThicknessValues;
      //  Create the request URL
      String url = '$baseUrl/api/wall_thickness_values?metadata_id=$MetadataId';

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

      String body = jsonEncode(getWallThicknessData);

      print(body.toString());

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // Navigate to the SubmitData page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubmitData()),
    );
  }

  // This is a wrapper function that handles the loading state
  void _handleSubmit() async {
    if (_lineEngineerController.text.isEmpty ||
        _shiftEngineerController.text.isEmpty ||
        _batchNoController.text.isEmpty) {
      // Show a warning message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the original submit function
      await Future.microtask(() => _submitData());
    } catch (e) {
      // Show error if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Make sure we reset the loading state if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _lineEngineerController,
          decoration: const InputDecoration(
            labelText: 'Line Engineer',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _shiftEngineerController,
          decoration: const InputDecoration(
            labelText: 'Shift Engineer',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _batchNoController,
          decoration: const InputDecoration(
            labelText: 'Batch No',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          // Disable the button when loading
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.lightBlue,
            minimumSize: const Size(double.infinity, 50),
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightBlue,
                      ),
                    ),
                  )
                  : const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
        ),
      ],
    );
  }
}
