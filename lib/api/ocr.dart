import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PhilIdApi {
  // Replace with your Flask server IP
  static const String baseUrl = "http://172.19.162.240:5001"; 

  /// Uploads the PhilID image to Flask for OCR extraction
  static Future<Map<String, dynamic>> extractInfo(File imageFile) async {
    final uri = Uri.parse('$baseUrl/extract-info');
    final request = http.MultipartRequest('POST', uri);

    // Attach image file
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    try {
      final response = await request.send();

      // Get response body
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(resBody);
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
          'message': resBody
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to connect to server',
        'message': e.toString(),
      };
    }
  }

  /// Optional: health check endpoint
  static Future<bool> checkHealth() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/health'));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
