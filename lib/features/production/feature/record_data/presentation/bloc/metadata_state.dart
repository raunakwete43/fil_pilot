abstract class MetadataState {}

class MetadataStateInitial extends MetadataState {}

class MetadataStateLoading extends MetadataState {}

class MetadataStateLoaded extends MetadataState {
  final int? pipeId;
  final int? metadataId;

  MetadataStateLoaded({this.pipeId, this.metadataId});
}

class MetadataStateError extends MetadataState {
  final String error;

  MetadataStateError({required this.error});
}
