import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  final String baseUrl = 'http://10.68.118.26:8000'; 

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String middleName,
    required String lastName,
    required String gender,
    required String role,
    required String department,
    required int licenseNumber,
    required int hospitalId,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register'); 

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'gender': gender,
        'role': role,
        'department': department,
        'licenseNumber': licenseNumber,
        'hospitalId': hospitalId,
        'email': email,
        'password': password,
      }),
    );

    return {
      'status': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}
