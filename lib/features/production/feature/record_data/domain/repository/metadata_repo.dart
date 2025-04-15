import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';

abstract interface class MetadataRepo {
  Future<MetadataResponse?> insertMetadata(MetadataRequest request);
  Future<PipeInfoResponse?> getPipeInfo(MetadataPipeRequest request);
  Future<int?> getPipeId(PipeInfoRequest request);
}
