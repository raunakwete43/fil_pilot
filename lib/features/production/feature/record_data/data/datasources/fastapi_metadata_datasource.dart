import 'dart:convert';

import 'package:fil_pilot/features/production/feature/record_data/domain/entities/metadata.dart';
import 'package:http/http.dart' as http;

class FastapiMetadataDatasource {
  final String baseUrl;

  FastapiMetadataDatasource({required this.baseUrl});

  Future<MetadataResponse?> insertMetadata(MetadataRequest request) async {
    final url = Uri.parse('$baseUrl/api/metadata');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return MetadataResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to insert metadata: ${response.body}');
      }
    } catch (e) {
      print('Error in insertMetadata: $e');
      return null;
    }
  }

  Future<PipeInfoResponse?> getPipeInfo(MetadataPipeRequest request) async {
    final url = Uri.parse('$baseUrl/api/get_pipe_info');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PipeInfoResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to get pipe info: ${response.body}');
      }
    } catch (e) {
      print('Error in getPipeInfo: $e');
      return null;
    }
  }

  Future<int?> getPipeId(PipeInfoRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/get_pipe_id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['pipe_id'];
      } else {
        throw Exception('Failed to get pipe info: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
