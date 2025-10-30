import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientApiService {
  static const String baseUrl = 'http://172.19.162.240:8004';
  
  static Future<Map<String, dynamic>> registerPatient({
    required Map<String, dynamic> patient,
    Map<String, dynamic>? visit,
    Map<String, dynamic>? vitalSigns,
    List<Map<String, dynamic>>? medications,
    List<Map<String, dynamic>>? medicalHistory,
    List<Map<String, dynamic>>? allergies,
    List<Map<String, dynamic>>? labResults,
    List<Map<String, dynamic>>? prescriptions,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/registerpatient');
      
      final body = {
        'patient': patient,
        if (visit != null) 'visit': visit,
        if (vitalSigns != null) 'vitalSigns': vitalSigns,
        if (medications != null) 'medications': medications,
        if (medicalHistory != null) 'medicalHistory': medicalHistory,
        if (allergies != null) 'allergies': allergies,
        if (labResults != null) 'labResults': labResults,
        if (prescriptions != null) 'prescriptions': prescriptions,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': responseData['message'] ?? 'Patient registered successfully',
          'patientId': responseData['patientId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to register patient. Status: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}