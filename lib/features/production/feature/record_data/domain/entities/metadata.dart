import 'package:intl/intl.dart';

class MetadataRequest {
  String machineNo;
  int? pipeId; // Make pipeId nullable
  int shiftNo;
  int recordNo;
  String? batchNo;
  String? lineEngineer;
  String? shiftIncharge;
  DateTime recordDate;

  MetadataRequest({
    required this.machineNo,
    this.pipeId, // Make pipeId optional
    required this.shiftNo,
    required this.recordNo,
    this.batchNo,
    this.lineEngineer,
    this.shiftIncharge,
    required this.recordDate,
  });

  factory MetadataRequest.fromJson(Map<String, dynamic> json) {
    return MetadataRequest(
      machineNo: json['machine_no'],
      pipeId: json['pipe_id'],
      shiftNo: json['shift_no'],
      recordNo: json['record_no'],
      batchNo: json['batch_no'],
      lineEngineer: json['line_engineer'],
      shiftIncharge: json['shift_incharge'],
      recordDate: DateFormat('yyyy-mm-dd').parse(json['record_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'machine_no': machineNo,
      'pipe_id': pipeId,
      'shift_no': shiftNo,
      'record_no': recordNo,
      'batch_no': batchNo,
      'line_engineer': lineEngineer,
      'shift_incharge': shiftIncharge,
      'record_date': DateFormat('yyyy-mm-dd').format(recordDate),
    };
  }

  MetadataRequest copyWith({
    String? machineNo,
    int? pipeId,
    int? shiftNo,
    int? recordNo,
    String? batchNo,
    String? lineEngineer,
    String? shiftIncharge,
    DateTime? recordDate,
  }) {
    return MetadataRequest(
      machineNo: machineNo ?? this.machineNo,
      pipeId: pipeId ?? this.pipeId,
      shiftNo: shiftNo ?? this.shiftNo,
      recordNo: recordNo ?? this.recordNo,
      batchNo: batchNo ?? this.batchNo,
      lineEngineer: lineEngineer ?? this.lineEngineer,
      shiftIncharge: shiftIncharge ?? this.shiftIncharge,
      recordDate: recordDate ?? this.recordDate,
    );
  }
}

class MetadataResponse {
  int metadataId;
  String machineNo;
  int pipeId;
  int shiftNo;
  int recordNo;
  String batchNo;
  String lineEngineer;
  String shiftIncharge;
  DateTime recordDate;

  MetadataResponse({
    required this.metadataId,
    required this.machineNo,
    required this.pipeId,
    required this.shiftNo,
    required this.recordNo,
    required this.batchNo,
    required this.lineEngineer,
    required this.shiftIncharge,
    required this.recordDate,
  });

  factory MetadataResponse.fromJson(Map<String, dynamic> json) {
    return MetadataResponse(
      metadataId: json['metadata_id'],
      machineNo: json['machine_no'],
      pipeId: json['pipe_id'],
      shiftNo: json['shift_no'],
      recordNo: json['record_no'],
      batchNo: json['batch_no'],
      lineEngineer: json['line_engineer'],
      shiftIncharge: json['shift_incharge'],
      recordDate: DateFormat('yyyy-mm-dd').parse(json['record_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata_id': metadataId,
      'machine_no': machineNo,
      'pipe_id': pipeId,
      'shift_no': shiftNo,
      'record_no': recordNo,
      'batch_no': batchNo,
      'line_engineer': lineEngineer,
      'shift_incharge': shiftIncharge,
      'record_date': DateFormat('yyyy-mm-dd').format(recordDate),
    };
  }
}

class MetadataPipeRequest {
  String machineNo;
  int shiftNo;
  int recordNo;
  DateTime recordDate;

  MetadataPipeRequest({
    required this.machineNo,
    required this.shiftNo,
    required this.recordNo,
    required this.recordDate,
  });

  factory MetadataPipeRequest.fromJson(Map<String, dynamic> json) {
    return MetadataPipeRequest(
      machineNo: json['machine_no'],
      shiftNo: json['shift_no'],
      recordNo: json['record_no'],
      recordDate: DateFormat('yyyy-mm-dd').parse(json['record_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'machine_no': machineNo,
      'shift_no': shiftNo,
      'record_no': recordNo,
      'record_date': DateFormat('yyyy-mm-dd').format(recordDate),
    };
  }
}

class PipeInfoResponse {
  int pipeId;
  String pipeSize;
  String pipeColor;

  PipeInfoResponse({
    required this.pipeId,
    required this.pipeSize,
    required this.pipeColor,
  });

  factory PipeInfoResponse.fromJson(Map<String, dynamic> json) {
    return PipeInfoResponse(
      pipeId: json['pipe_id'],
      pipeSize: json['pipe_size'],
      pipeColor: json['pipe_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pipe_id': pipeId,
      'pipe_size': pipeSize,
      'pipe_color': pipeColor,
    };
  }
}

class PipeInfoRequest {
  String pipeSize;
  String pipeClass;

  PipeInfoRequest({
    required this.pipeSize,
    required this.pipeClass,
  });

  factory PipeInfoRequest.fromJson(Map<String, dynamic> json) {
    return PipeInfoRequest(
        pipeSize: json['pipe_size'], pipeClass: json['pipe_class']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pipe_size': pipeSize,
      'pipe_class': pipeClass,
    };
  }
}
