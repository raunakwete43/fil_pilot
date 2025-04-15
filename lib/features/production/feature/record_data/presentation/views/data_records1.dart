import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/views/data_records2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataRecords1 extends StatelessWidget {
  // List of parameters, UOMs, and controllers for operating and actual values
  final List<Map<String, dynamic>> parameters = [
    {'parameter_id': 1, 'parameter': 'Screw Speed', 'uom': 'RPM'},
    {'parameter_id': 2, 'parameter': 'Main Motor Load', 'uom': '%Amps'},
    {'parameter_id': 3, 'parameter': 'Dosser Speed', 'uom': 'RPM'},
    {'parameter_id': 4, 'parameter': 'Main Synchro', 'uom': ''},
    {'parameter_id': 5, 'parameter': 'Haul Off Speed (No. 1)', 'uom': 'RPM'},
    {'parameter_id': 6, 'parameter': 'Haul Off Speed (No. 2)', 'uom': 'RPM'},
    {'parameter_id': 7, 'parameter': 'Back Thrust', 'uom': 'KN'},
    {'parameter_id': 8, 'parameter': 'Barrel Vacuum', 'uom': 'Kg/Cm²'},
    {'parameter_id': 9, 'parameter': 'Screw H/C Temperature', 'uom': '°C'},
    {'parameter_id': 10, 'parameter': 'Melt Temprature', 'uom': '°C'},
    {
      'parameter_id': 11,
      'parameter': 'Barrel Zone Temperature :Z1',
      'uom': '°C'
    },
    {'parameter_id': 12, 'parameter': ' :Z2', 'uom': '°C'},
    {'parameter_id': 13, 'parameter': ' :Z3', 'uom': '°C'},
    {'parameter_id': 14, 'parameter': ' :Z4', 'uom': '°C'},
    {'parameter_id': 15, 'parameter': ' :Z5', 'uom': '°C'},
    {'parameter_id': 16, 'parameter': 'Adapter Zone Temp', 'uom': '°C'},
    {'parameter_id': 17, 'parameter': 'Die Head Zone Temp :T1', 'uom': '°C'},
    {'parameter_id': 18, 'parameter': ' :T2', 'uom': '°C'},
    {'parameter_id': 19, 'parameter': ' :T3', 'uom': '°C'},
    {'parameter_id': 20, 'parameter': ' :T4', 'uom': '°C'},
    {'parameter_id': 21, 'parameter': ' :T5', 'uom': '°C'},
    {'parameter_id': 22, 'parameter': ' :T6', 'uom': '°C'},
    {'parameter_id': 23, 'parameter': ' :T7', 'uom': '°C'},
    {'parameter_id': 24, 'parameter': ' :T8', 'uom': '°C'},
    {'parameter_id': 25, 'parameter': ' :T9', 'uom': '°C'},
    {'parameter_id': 26, 'parameter': ' :T10', 'uom': '°C'},
    {'parameter_id': 27, 'parameter': ' :T11', 'uom': '°C'},
    {'parameter_id': 28, 'parameter': ' :T12', 'uom': '°C'},
    {'parameter_id': 29, 'parameter': 'Tank Vacuum (No. 1)', 'uom': 'Kg/Cm²'},
    {'parameter_id': 30, 'parameter': 'Tank Vacuum (No. 2)', 'uom': 'Kg/Cm²'},
    {'parameter_id': 31, 'parameter': 'Time / Pipe', 'uom': 'Sec.'},
    {'parameter_id': 32, 'parameter': 'Output', 'uom': 'Kg/Day'},
    {'parameter_id': 33, 'parameter': 'Outer Diameter', 'uom': 'mm'},
    {'parameter_id': 34, 'parameter': 'Wall Thickness', 'uom': 'mm'},
    {'parameter_id': 35, 'parameter': 'Length', 'uom': 'm'},
  ];

  DataRecords1({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for data entry
    // ignore: unused_local_variable
    final List<TextEditingController> operatingControllers =
        List.generate(parameters.length, (index) => TextEditingController());
    final List<TextEditingController> actualControllers =
        List.generate(parameters.length, (index) => TextEditingController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Pipe Parameters',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Table Header
            const Row(
              children: [
                Expanded(child: Text('Parameters', style: _headerStyle)),
                Expanded(child: Text('UOM', style: _headerStyle)),
                // Expanded(child: Text('Operating Values', style: _headerStyle)),
                Expanded(child: Text('Actual Values', style: _headerStyle)),
              ],
            ),
            const Divider(thickness: 2),
            // Table Rows
            Expanded(
              child: ListView.builder(
                itemCount: parameters.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          parameters[index]['parameter']!,
                          style: _cellStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          parameters[index]['uom']!,
                          style: _cellStyle,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: actualControllers[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  bool allFieldsFilled = true;
                  for (var controller in actualControllers) {
                    if (controller.text.isEmpty) {
                      allFieldsFilled = false;
                      break;
                    }
                  }

                  if (!allFieldsFilled) {
                    // Show a warning message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please fill all fields before submitting.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Exit the function if any field is empty
                  }

                  // Handle submission of data
                  final List<Map<String, dynamic>> pipeData = [];
                  for (int i = 0; i < parameters.length; i++) {
                    pipeData.add({
                      'parameter_id': parameters[i]['parameter_id'],
                      'parameter': parameters[i]['parameter'],
                      'uom': parameters[i]['uom'],
                      // 'operatingValue': operatingControllers[i].text,
                      'actual_value': actualControllers[i].text,
                    });
                  }

                  try {
                    List<Map<String, dynamic>> bodyData = pipeData.map((item) {
                      double actualValue =
                          double.tryParse(item['actual_value']) ?? 0.0;
                      return {
                        'parameter_id': item['parameter_id'],
                        'actual_value': actualValue,
                      };
                    }).toList();

                    context.read<DataRecordsCubit>().saveDataRecords(bodyData);
                  } catch (e) {}

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DataRecords2()));

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.lightBlue,
                    minimumSize: const Size(double.infinity, 50),
                  );
                }),
          ],
        ),
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle _cellStyle = TextStyle(
    fontSize: 14,
  );
}
