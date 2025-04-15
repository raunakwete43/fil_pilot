import 'package:fil_pilot/features/production/feature/record_data/data/datasources/fastapi_metadata_datasource.dart';
import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
import 'package:fil_pilot/features/production/feature/record_data/domain/repository/metadata_repo.dart';
import 'package:fil_pilot/main.dart';

class FastapiMetadataRepoImpl implements MetadataRepo {
  final FastapiMetadataDatasource _fastapiMetadataDatasource =
      FastapiMetadataDatasource(baseUrl: baseUrl);

  @override
  Future<PipeInfoResponse?> getPipeInfo(MetadataPipeRequest request) {
    return _fastapiMetadataDatasource.getPipeInfo(request);
  }

  @override
  Future<MetadataResponse?> insertMetadata(MetadataRequest request) {
    return _fastapiMetadataDatasource.insertMetadata(request);
  }

  @override
  Future<int?> getPipeId(PipeInfoRequest request) {
    return _fastapiMetadataDatasource.getPipeId(request);
  }
}
