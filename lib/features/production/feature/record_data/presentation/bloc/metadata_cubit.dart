import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
import 'package:fil_pilot/features/production/feature/record_data/domain/repository/metadata_repo.dart';
import 'package:fil_pilot/features/production/feature/record_data/presentation/bloc/metadata_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Assuming this contains MetadataRequest, MetadataResponse, etc.

class MetadataCubit extends Cubit<MetadataState> {
  final MetadataRepo metadataRepo;

  MetadataCubit({required this.metadataRepo}) : super(MetadataStateInitial());

  late MetadataRequest _metadataSaved;
  late PipeInfoRequest _pipeinfo;
  bool shouldLoadPipe = false;
  late int _metadataId;

  Future<void> savePipeInfo(PipeInfoRequest request) async {
    _pipeinfo = request;
  }

  Future<void> saveMetadata1(MetadataRequest request) async {
    if (request.recordNo != 1) {
      print("Skip");
      shouldLoadPipe = true;
    } else {
      print("Save");
      shouldLoadPipe = false;
    }
    _metadataSaved = request;
  }

  Future<void> saveMetadata2(PipeInfoRequest request) async {
    print("Save m2");
    final pipeId = await metadataRepo.getPipeId(request);

    _metadataSaved = MetadataRequest(
      machineNo: _metadataSaved.machineNo,
      pipeId: pipeId,
      shiftNo: _metadataSaved.shiftNo,
      recordNo: _metadataSaved.recordNo,
      batchNo: _metadataSaved.batchNo,
      lineEngineer: _metadataSaved.lineEngineer,
      shiftIncharge: _metadataSaved.shiftIncharge,
      recordDate: _metadataSaved.recordDate,
    );
  }

  /// Insert Metadata
  Future<void> insertMetadata(MetadataRequest request) async {
    emit(MetadataStateLoading());
    try {
      final response = await metadataRepo.insertMetadata(request);
      print(response);
      if (response != null) {
        _metadataId = response.metadataId;
        print("MetadataID $_metadataId");
        emit(MetadataStateLoaded());
      } else {
        emit(MetadataStateError(error: "Failed tp insert metadata"));
      }
    } catch (e) {
      emit(MetadataStateError(error: e.toString()));
    }
  }

  // /// Get Pipe Info
  // Future<void> getPipeInfo(MetadataPipeRequest request) async {
  //   emit(MetadataStateLoading());
  //   try {
  //     final response = await metadataRepo.getPipeInfo(request);
  //     // print(response);
  //     if (response != null) {
  //       emit(MetadataStateLoaded());
  //       _pipeInfoResponse = response;
  //       // print("Pipe Response $response");
  //       _metadataSaved = MetadataRequest(
  //         machineNo: _metadataSaved.machineNo,
  //         pipeId: _pipeInfoResponse.pipeId,
  //         shiftNo: _metadataSaved.shiftNo,
  //         recordNo: _metadataSaved.recordNo,
  //         batchNo: _metadataSaved.batchNo,
  //         lineEngineer: _metadataSaved.lineEngineer,
  //         shiftIncharge: _metadataSaved.shiftIncharge,
  //         recordDate: _metadataSaved.recordDate,
  //       );
  //     } else {
  //       emit(MetadataStateError(error: 'Failed to fetch pipe info.'));
  //     }
  //   } catch (e) {
  //     emit(MetadataStateError(error: e.toString()));
  //   }
  // }

  MetadataRequest get metadataSaved => _metadataSaved;
  // PipeInfoResponse get pipeInfoResponse => _pipeInfoResponse;
  int get metadataId => _metadataId;
  PipeInfoRequest get pipeInfoRequest => _pipeinfo;
}
