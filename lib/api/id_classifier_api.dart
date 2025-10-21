// lib/api/id_classifier_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class IdClassifierApi {
  //Replace this with your local IP or deployed server IP
  static const String _baseUrl = "http://10.172.22.240:5050"; 

  /// Sends an image to the Flask /classify endpoint
  static Future<Map<String, dynamic>> classifyId(File imageFile) async {
    try {
      final uri = Uri.parse("$_baseUrl/classify");
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return jsonDecode(responseData.body);
      } else {
        return {
          "error": "Server responded with status ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "error": e.toString(),
      };
    }
  }
}
