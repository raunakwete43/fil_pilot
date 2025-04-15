import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/views/data_records3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataRecords2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SocketingMachineConditionReport()));
  }
}

class SocketingMachineConditionReport extends StatefulWidget {
  // List of parameters
  final List<Map<String, dynamic>> parameters = [
    {'parameter_id': 36, 'parameter': 'Socket Length', 'uom': 'mm'},
    {'parameter_id': 37, 'parameter': 'Socket Fitting', 'uom': 'OK/Not Ok'},
    {'parameter_id': 38, 'parameter': 'Oven/Jacket Temp.1', 'uom': '°C'},
    {'parameter_id': 39, 'parameter': 'Oven/Jacket Temp.2', 'uom': '°C'},
    {'parameter_id': 40, 'parameter': 'Heating Time 1', 'uom': 'Sec'},
    {'parameter_id': 41, 'parameter': 'Heating Time 2', 'uom': 'Sec'},
    {'parameter_id': 42, 'parameter': 'Cooling Time', 'uom': 'Sec'},
    {'parameter_id': 43, 'parameter': 'Blow Air Pressure', 'uom': 'Kg/cm'},
  ];

  SocketingMachineConditionReport({super.key});

  @override
  _SocketingMachineConditionReportState createState() =>
      _SocketingMachineConditionReportState();
}

class _SocketingMachineConditionReportState
    extends State<SocketingMachineConditionReport> {
  // Controllers for data entry
  late final List<TextEditingController> _controllers;
  late final List<List<TextEditingController>> _downtimeControllers;
  late final List<List<TextEditingController>> _wastageControllers;

  String _dropdownValue = 'OK'; // Move this here

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.parameters.length,
      (index) => TextEditingController(),
    );
    _downtimeControllers = List.generate(
      3,
      (index) => List.generate(5, (index) => TextEditingController()),
    );
    _wastageControllers = List.generate(
      3,
      (index) => List.generate(3, (index) => TextEditingController()),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var row in _downtimeControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    for (var row in _wastageControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Socketing Machine Condition Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Parameters:', style: _headerStyle),
              const Divider(thickness: 2),
              _buildParametersTable(),
              const SizedBox(height: 20),
              const Text('DOWNTIME DETAILS:', style: _headerStyle),
              const Divider(thickness: 2),
              _buildDowntimeTable(),
              const SizedBox(height: 20),
              const Text('WASTAGE DETAILS:', style: _headerStyle),
              const Divider(thickness: 2),
              _buildWastageTable(),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  bool allParameterFieldsFilled = true;
                  for (var controller in _controllers) {
                    if (controller.text.isEmpty) {
                      allParameterFieldsFilled = false;
                      break;
                    }
                  }

                  if (!allParameterFieldsFilled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields before submitting.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Exit the function if any field is empty
                  }

                  // Handle submission of data
                  final List<Map<String, dynamic>> socketData = [];
                  for (int i = 0; i < widget.parameters.length; i++) {
                    socketData.add({
                      'parameter_id': widget.parameters[i]['parameter_id'],
                      'parameter': widget.parameters[i]['parameter'],
                      'uom': widget.parameters[i]['uom'],
                      'actual_value': _controllers[i].text,
                    });
                  }

                  try {
                    List<Map<String, dynamic>> bodyData =
                        socketData.map((item) {
                          String actualValue = item['actual_value'].toString();
                          return {
                            'parameter_id': item['parameter_id'],
                            'actual_value': actualValue,
                          };
                        }).toList();

                    // Collect downtime details
                    final List<Map<String, String>> downtimeData = [];
                    for (int i = 0; i < _downtimeControllers.length; i++) {
                      downtimeData.add({
                        'code': _downtimeControllers[i][0].text,
                        'reason': _downtimeControllers[i][1].text,
                        'from_': _downtimeControllers[i][2].text,
                        'to': _downtimeControllers[i][3].text,
                        'total_hrs': _downtimeControllers[i][4].text,
                      });
                    }

                    // Collect wastage details
                    final List<Map<String, String>> wastageData = [];
                    for (int i = 0; i < _wastageControllers.length; i++) {
                      wastageData.add({
                        'code': _wastageControllers[i][0].text,
                        'reason': _wastageControllers[i][1].text,
                        'wastage': _wastageControllers[i][2].text,
                      });
                    }

                    context.read<DataRecordsCubit>().saveSocketData(bodyData);
                    context.read<DataRecordsCubit>().saveDetails(
                      downtimeData,
                      wastageData,
                    );

                    print(
                      "${context.read<DataRecordsCubit>().getDownTimeData}\n${context.read<DataRecordsCubit>().getWastageData}",
                    );
                    print(
                      context.read<DataRecordsCubit>().getSocketData.toString(),
                    );
                  } on Exception catch (e) {
                    print(e.toString());
                  }

                  // Navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataRecords3(),
                    ),
                  );
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
    );
  }

  static const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  Widget _buildParametersTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        dataRowMinHeight: 40,
        columns: const [
          DataColumn(label: Text('Parameter', style: boldStyle)),
          DataColumn(label: Text('UOM', style: boldStyle)),
          DataColumn(label: Text('Value', style: boldStyle)),
        ],
        rows: List.generate(widget.parameters.length, (index) {
          final parameter = widget.parameters[index];
          final isSocketFitting = parameter['parameter_id'] == 37;

          return DataRow(
            cells: [
              DataCell(Text(parameter['parameter']!)),
              DataCell(Text(parameter['uom']!)),
              DataCell(
                isSocketFitting
                    ? SizedBox(
                      width: 80, // Adjust width as needed
                      child: DropdownButton<String>(
                        value:
                            _dropdownValue, // Assume _dropdownValue is a state variable
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                            _controllers[index].text = newValue;
                          });
                        },
                        items:
                            <String>[
                              'OK',
                              'Not Ok',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                    )
                    : SizedBox(
                      width: 80, // Adjust width as needed
                      child: TextField(
                        controller: _controllers[index],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                        ),
                        keyboardType: TextInputType.number,
                        minLines: 1, // Minimum height of the TextField
                        maxLines: null, // Allows TextField to expand vertically
                      ),
                    ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDowntimeTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        dataRowMinHeight: 40,
        columns: const [
          DataColumn(label: Text('Code', style: boldStyle)),
          DataColumn(label: Text('Reasons', style: boldStyle)),
          DataColumn(label: Text('From', style: boldStyle)),
          DataColumn(label: Text('To', style: boldStyle)),
          DataColumn(label: Text('Total Hours', style: boldStyle)),
        ],
        rows: List.generate(
          _downtimeControllers.length,
          (index) => DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 100, // Adjust width as needed
                  child: TextField(
                    controller: _downtimeControllers[index][0],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 200, // Adjust width as needed.
                  child: TextField(
                    controller: _downtimeControllers[index][1],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100, // Adjust width as needed
                  child: TextField(
                    controller: _downtimeControllers[index][2],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100, // Adjust width as needed
                  child: TextField(
                    controller: _downtimeControllers[index][3],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120, // Adjust width as needed
                  child: TextField(
                    controller: _downtimeControllers[index][4],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWastageTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        dataRowMinHeight: 40,
        columns: const [
          DataColumn(label: Text('Code', style: boldStyle)),
          DataColumn(label: Text('Reasons', style: boldStyle)),
          DataColumn(label: Text('Wastage (kg)', style: boldStyle)),
        ],
        rows: List.generate(
          _wastageControllers.length,
          (index) => DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 100, // Adjust width as needed
                  child: TextField(
                    controller: _wastageControllers[index][0],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 200, // Adjust width as needed
                  child: TextField(
                    controller: _wastageControllers[index][1],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120, // Adjust width as needed
                  child: TextField(
                    controller: _wastageControllers[index][2],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}
