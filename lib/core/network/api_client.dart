import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${AppConstants.baseUrl}/$endpoint');
    print('Fetching data from: $url'); // Debug log
    try {
      final response = await client.get(url);
      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in API call: $e'); // Debug log
      throw Exception('Failed to load data from $endpoint: $e');
    }
  }
}