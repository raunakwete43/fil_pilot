import 'package:fil_pilot/common/utils/url_config.dart';
import 'package:fil_pilot/features/login/data/user_login_repo_impl.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_cubit.dart';
import 'package:fil_pilot/features/login/presentation/views/login.dart';
import 'package:fil_pilot/features/production/feature/record_data/data/fastapi_metadata_repo_impl.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_cubit.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// We'll use dynamic URL from UrlConfig instead of hardcoding it here
String baseUrl = UrlConfig.defaultUrl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the baseUrl from saved preferences
  baseUrl = await UrlConfig.getServerUrl();
  
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
      child: const MyApp(),
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
