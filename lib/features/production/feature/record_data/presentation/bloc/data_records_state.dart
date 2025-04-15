abstract class DataRecordsState {}

class DataRecordsInitial extends DataRecordsState {}

class DataRecordsLoading extends DataRecordsState {}

class DataRecordsLoaded extends DataRecordsState {
  final List<Map<String, dynamic>> bodyData;
  late List<Map<String, dynamic>> socketData;

  DataRecordsLoaded({required this.bodyData, required this.socketData});
}

class DataRecordsError extends DataRecordsState {
  final String error;

  DataRecordsError({required this.error});
}
