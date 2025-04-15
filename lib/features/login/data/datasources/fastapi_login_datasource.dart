import 'dart:convert';

import 'package:http/http.dart' as http;

class FastapiLoginDatasource {
  final String baseUrl;

  FastapiLoginDatasource({required this.baseUrl});

  Future<Map<dynamic, dynamic>?> loginWithNameandNo(
      String name, String empNo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        body: json.encode({"name": name, "empNo": empNo}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
