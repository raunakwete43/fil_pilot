// import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
// import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_cubit.dart';
// import 'package:fil_pilot/features/production/feature/record_data/presentation/views/custom_text_input.dart';
// import 'package:fil_pilot/features/production/feature/record_data/presentation/views/data_records1.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PipeParametersPage extends StatefulWidget {
//   const PipeParametersPage({super.key});

//   @override
//   State<PipeParametersPage> createState() => _PipeParametersPageState();
// }

// class _PipeParametersPageState extends State<PipeParametersPage> {
//   final TextEditingController pipeSizeController = TextEditingController();
//   final TextEditingController pipeColorController = TextEditingController();
//   final TextEditingController wallThicknessController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadPipe();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadPipe();
//   }

//   void _loadPipe() {
//     bool shouldLoadPipe = context.read<MetadataCubit>().shouldLoadPipe;
//     if (shouldLoadPipe) {
//       final PipeInfoResponse pipeInfo =
//           context.read<MetadataCubit>().pipeInfoResponse;
//       pipeSizeController.text = pipeInfo.pipeSize;
//       pipeColorController.text = pipeInfo.pipeColor;
//       wallThicknessController.text = pipeInfo.thickness;
//       weightController.text = pipeInfo.weight;
//     } else {
//       pipeColorController.clear();
//       pipeSizeController.clear();
//       wallThicknessController.clear();
//       weightController.clear();
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose controllers when the page is removed from the widget tree
//     pipeSizeController.dispose();
//     pipeColorController.dispose();
//     wallThicknessController.dispose();
//     weightController.dispose();
//     super.dispose();
//   }

//   // Method to validate fields and handle the Next button
//   void _handleNext(BuildContext context) async {
//     if (pipeSizeController.text.isEmpty ||
//         pipeColorController.text.isEmpty ||
//         wallThicknessController.text.isEmpty ||
//         weightController.text.isEmpty) {
//       // Show error message if any field is empty
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please fill all fields before proceeding!')),
//       );
//     } else {
//       String pipeSize = pipeSizeController.text;
//       String pipeColor = pipeColorController.text;
//       String thickness = wallThicknessController.text;
//       String weight = weightController.text;

//       PipeInfoRequest _pipeInfoRequest = PipeInfoRequest(
//         pipeSize: pipeSize,
//         pipeColor: pipeColor,
//         thickness: thickness,
//         weight: weight,
//       );

//       await context.read<MetadataCubit>().saveMetadata2(_pipeInfoRequest);

//       MetadataRequest mr = context.read<MetadataCubit>().metadataSaved;

//       await context.read<MetadataCubit>().insertMetadata(mr);
//       print(mr.toJson());

//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => DataRecords1()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         title: const Text(
//           'Pipe Parameters',
//           style: TextStyle(
//             color: Colors.lightBlue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             'lib/common/icons/fil_logo.png',
//             width: 100,
//             height: 40,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomTextField(
//                 label: 'Pipe Size',
//                 controller: pipeSizeController,
//                 keyboardType: TextInputType.number,
//               ),
//               CustomTextField(
//                 label: 'Pipe Color',
//                 controller: pipeColorController,
//               ),
//               CustomTextField(
//                 label: 'Std. Wall Thickness',
//                 controller: wallThicknessController,
//                 keyboardType: TextInputType.number,
//               ),
//               CustomTextField(
//                 label: 'Std. Weight',
//                 controller: weightController,
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _handleNext(context),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(250, 50),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Next'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
