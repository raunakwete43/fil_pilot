import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/data_records_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataRecordsCubit extends Cubit<DataRecordsState> {
  late List<Map<String, dynamic>> bodyData;
  late List<Map<String, dynamic>> socketData;
  late List<Map<String, dynamic>> downtimeData;
  late List<Map<String, dynamic>> wastageData;
  late Map<String, List<String>> wallThicknessValues;

  DataRecordsCubit() : super(DataRecordsInitial());

  Future<void> saveWallData(Map<String, List<String>> values) async {
    wallThicknessValues = values;
  }

  Future<void> saveDataRecords(List<Map<String, dynamic>> data_records) async {
    emit(DataRecordsLoading());

    bodyData = data_records;

    emit(DataRecordsLoaded(bodyData: data_records, socketData: []));
  }

  Future<void> saveSocketData(List<Map<String, dynamic>> data_records) async {
    emit(DataRecordsLoading());

    socketData = data_records;

    emit(DataRecordsLoaded(bodyData: bodyData, socketData: socketData));
  }

  Future<void> saveDetails(
    List<Map<String, dynamic>> downtimeDetails,
    wastageDetails,
  ) async {
    downtimeData = downtimeDetails;
    wastageData = wastageDetails;
  }

  Future<void> getShiftInfo() async {}

  List<Map<String, dynamic>> get getBodyData => bodyData;
  List<Map<String, dynamic>> get getSocketData => socketData;
  List<Map<String, dynamic>> get getDownTimeData => downtimeData;
  List<Map<String, dynamic>> get getWastageData => wastageData;
  Map<String, List<String>> get getWallThicknessValues => wallThicknessValues;
}
