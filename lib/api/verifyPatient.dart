import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientAPI {
  // Replace with your actual server URL
  static const String baseUrl = 'http://172.19.162.240:8005';

  /// Verify patient by ID number
  /// Returns a Map with the response data
  static Future<Map<String, dynamic>> verifyPatient(String idNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idNumber': idNumber}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Server returned status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error connecting to server: ${e.toString()}',
      };
    }
  }
}