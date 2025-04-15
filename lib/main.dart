import 'package:fil_pilot/features/login/data/user_login_repo_impl.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_cubit.dart';
import 'package:fil_pilot/features/login/presentation/views/login.dart';
import 'package:fil_pilot/features/production/feature/record_data/data/fastapi_metadata_repo_impl.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import ProductionScreen

const baseUrl = "http://192.168.108.82:8000";

void main() {
  final UserLoginRepoImpl userLoginRepo = UserLoginRepoImpl();
  final FastapiMetadataRepoImpl fastapiMetadataRepo = FastapiMetadataRepoImpl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(userLoginRepo: userLoginRepo)),
        BlocProvider(
          create: (_) => MetadataCubit(metadataRepo: fastapiMetadataRepo),
        ),
        BlocProvider(create: (_) => DataRecordsCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(), // Directly open the ProductionScreen
    );
  }
}
