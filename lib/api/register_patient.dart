import 'dart:convert';
import 'package:http/http.dart' as http;


const String baseUrl = 'http://172.19.162.240:8004';

class PatientApi {
  static Future<bool> registerPatient(Map<String, dynamic> patientData) async {
    final url = Uri.parse('$baseUrl/registerpatient');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(patientData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
