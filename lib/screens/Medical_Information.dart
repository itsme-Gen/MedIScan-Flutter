import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/api/register_patient.dart';

class MedicalData {
  static final Map<String, TextEditingController> _controllers = {};
  DateTime? dateStarted;
  List<String> currentMedicationsList = [];
  
  String selectedConditionType = 'Condition Type';
  String selectedSeverity = 'Severity';
  String selectedConditionStatus = 'Condition Status';
  String selectedAllergySeverity = 'Severity';
  String selectedFlag = 'Flag';
  DateTime? diagnoseDate, revolutionDate, testDate, dateGiven, nextDue, dateOfPrescribe;
  List<String> medicalHistory = [];
  List<String> allergiesList = [];
  List<String> labResultsList = [];
  List<String> immunizationsList = [];
  List<String> prescriptionsList = [];

  static TextEditingController getController(String key) => _controllers.putIfAbsent(key, () => TextEditingController());
  static void resetAll() => _controllers.values.forEach((c) => c.clear());
}

class MedicalInformation extends StatefulWidget {
  final Map<String, String> patientData;
  final MedicalData? sharedData;
  const MedicalInformation({super.key, required this.patientData, this.sharedData});

  @override
  State<MedicalInformation> createState() => _MedicalInformationState();
}

class _MedicalInformationState extends State<MedicalInformation> {
  late MedicalData data;
  int currentPage = 0;
  bool isLoading = false;

  final conditionTypes = ['Condition Type', 'N/A', 'Chronic', 'Acute', 'Infectious', 'General', 'Mental Health', 'Auto immune', 'Cancer', 'Cardiovascular', 'Respiratory', 'Neurological', 'Pregnancy Complication', 'Congenital', 'Substance Abuse'];
  final severityOptions = ['Severity', 'Mild', 'Moderate', 'Severe'];
  final conditionStatusOptions = ['Condition Status', 'Active', 'Progressive', 'Resolved'];
  final flagOptions = ['Flag', 'Normal', 'High', 'Low'];

  @override
  void initState() {
    super.initState();
    data = widget.sharedData ?? MedicalData();
  }

  Widget _card(String title, String subtitle, Widget child, IconData icon) => Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
        ]),
        if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        SizedBox(height: 12),
        child,
      ],
    ),
  );

  Widget _input(String label, String key, {String hint = '', int maxLines = 1}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      TextField(
        controller: MedicalData.getController(key),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.all(12),
        ),
        style: TextStyle(fontSize: 10),
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _date(String label, DateTime? date, Function(DateTime) onSelect) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
          if (picked != null) onSelect(picked);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Expanded(child: Text(date?.toLocal().toString().split(' ')[0] ?? 'dd/mm/yyyy', style: TextStyle(fontSize: 10, color: date != null ? Colors.black : Colors.grey.shade600))),
            Icon(LucideIcons.calendar, size: 16, color: Colors.grey),
          ]),
        ),
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _dropdown(String label, String currentValue, List<String> options, Function(String?) onChanged) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: EdgeInsets.all(12)),
        isExpanded: true,
        style: TextStyle(fontSize: 10, color: Colors.black),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option, style: TextStyle(fontSize: 10)))).toList(),
        onChanged: onChanged,
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _patientInfo(String label, String value) => Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    ),
  );

  Widget _listItem(String text, int index, List<String> list) => Container(
    margin: EdgeInsets.only(top: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
    child: Row(children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: text.split('\n').map((line) {
          if (line.contains(':')) {
            final parts = line.split(':');
            return RichText(text: TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.black),
              children: [
                TextSpan(text: '${parts[0].trim()}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: parts.length > 1 ? parts[1].trim() : ''),
              ],
            ));
          }
          return Text(line, style: TextStyle(fontSize: 12, color: Colors.black));
        }).toList(),
      )),
      IconButton(icon: Icon(LucideIcons.trash_2, color: Colors.red, size: 16), onPressed: () => setState(() => list.removeAt(index))),
    ]),
  );

  Widget _medicationItem(int index) {
    final lines = data.currentMedicationsList[index].split('\n');
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            if (line.contains(':')) {
              final parts = line.split(':');
              return RichText(text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(text: '${parts[0].trim()}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: parts.length > 1 ? parts[1].trim() : ''),
                ],
              ));
            }
            return Text(line, style: TextStyle(fontSize: 12, color: Colors.black));
          }).toList(),
        )),
        IconButton(icon: Icon(LucideIcons.trash_2, color: Colors.red, size: 16), onPressed: () => setState(() => data.currentMedicationsList.removeAt(index))),
      ]),
    );
  }

  Widget _addButton(String text, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(text, style: TextStyle(fontSize: 14)),
    ),
  );

  void _addMedication() {
    final name = MedicalData.getController('medicationName').text;
    final dosage = MedicalData.getController('dosage').text;
    final frequency = MedicalData.getController('frequency').text;
    
    if (name.isNotEmpty && data.dateStarted != null && dosage.isNotEmpty && frequency.isNotEmpty) {
      setState(() {
        data.currentMedicationsList.add('Medication Name: $name\nDate Started: ${data.dateStarted!.toLocal().toString().split(' ')[0]}\nDosage: $dosage\nFrequency: $frequency');
        for (var key in ['medicationName', 'dosage', 'frequency']) {
          MedicalData.getController(key).clear();
        }
        data.dateStarted = null;
      });
    }
  }

  void _addToList(List<String> list, String Function() buildEntry, List<String> requiredFields, List<dynamic> requiredValues) {
    bool allValid = requiredFields.every((field) => MedicalData.getController(field).text.isNotEmpty) && requiredValues.every((value) => value != null);
    if (allValid) {
      setState(() {
        list.add(buildEntry());
        for (var field in requiredFields) {
          MedicalData.getController(field).clear();
        }
        _resetDropdowns();
      });
    }
  }

  void _resetDropdowns() {
    data.selectedConditionType = 'Condition Type';
    data.selectedSeverity = 'Severity';
    data.selectedConditionStatus = 'Condition Status';
    data.selectedAllergySeverity = 'Severity';
    data.selectedFlag = 'Flag';
    data.diagnoseDate = data.revolutionDate = data.testDate = data.dateGiven = data.nextDue = data.dateOfPrescribe = null;
  }

  Future<void> _saveToRecords() async {
    if (isLoading) return;
    
    setState(() => isLoading = true);

    try {
      // Parse full name into first, middle, last
      final nameParts = (widget.patientData["Full Name"] ?? "").split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'N/A';
      final lastName = nameParts.length > 1 ? nameParts.last : 'N/A';
      final middleName = nameParts.length == 3 ? nameParts[1] : 'N/A';

      // Build patient data as Map - matches PatientSchema
      final patientData = {
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'id_number': widget.patientData["ID Number"] ?? 'N/A',
        'date_of_birth': widget.patientData["Birth Date"] ?? 'N/A',
        'gender': widget.patientData["Gender"] ?? 'N/A',
        'contact_number': int.tryParse(MedicalData.getController('contactNumber').text) ?? 0,
        'email_address': MedicalData.getController('email').text.isEmpty ? 'N/A' : MedicalData.getController('email').text,
        'home_address': MedicalData.getController('homeAddress').text.isEmpty ? 'N/A' : MedicalData.getController('homeAddress').text,
        'emergency_contact_number': int.tryParse(MedicalData.getController('emergencyContact').text) ?? 0,
      };

      // Build visit data as Map - matches VisitSchema
      final visitData = {
        'reason_for_visit': MedicalData.getController('reasonForVisit').text.isEmpty ? 'N/A' : MedicalData.getController('reasonForVisit').text,
      };

      // Build vital signs as Map - matches vitalSignSchema
      final vitalSignsData = {
        'body_temperature': MedicalData.getController('bodyTemp').text,
        'heart_pulse': MedicalData.getController('heartPulse').text,
        'respiratory_rate': MedicalData.getController('respiratoryRate').text,
        'blood_pressure': MedicalData.getController('bloodPressure').text,
        'date_recorded': DateTime.now().toIso8601String(),
      };

      // Build medications list - matches medicationSchema
      final medicationsList = data.currentMedicationsList.map((med) {
        final lines = med.split('\n');
        return {
          'medication_name': _extractValue(lines, 'Medication Name') ?? 'N/A',
          'start_date': _extractValue(lines, 'Date Started') ?? DateTime.now().toString().split(' ')[0],
          'dosage': _extractValue(lines, 'Dosage') ?? 'N/A',
          'frequency': _extractValue(lines, 'Frequency') ?? 'N/A',
        };
      }).toList();

      // Build medical history list - matches MedicalHistorySchema
      final medicalHistoryList = data.medicalHistory.map((hist) {
        final lines = hist.split('\n');
        return {
          'condition_name': _extractValue(lines, 'Condition Name') ?? 'N/A',
          'diagnose_date': _extractValue(lines, 'Diagnose Date') ?? DateTime.now().toIso8601String(),
          'condition_type': _extractValue(lines, 'Condition Type') ?? 'N/A',
          'severity': _extractValue(lines, 'Severity') ?? 'N/A',
          'status': _extractValue(lines, 'Condition Status') ?? 'N/A',
          'resolution_date': _extractValue(lines, 'Resolution Date') ?? null,
        };
      }).toList();

      // Build allergies list - matches allergiesSchema
      final allergiesList = data.allergiesList.map((allergy) {
        final lines = allergy.split('\n');
        return {
          'allergen_name': _extractValue(lines, 'Allergy Name') ?? 'N/A',
          'allergy_type': _extractValue(lines, 'Allergy Type') ?? 'N/A',
          'reaction': _extractValue(lines, 'Allergy Reaction') ?? 'N/A',
          'severity': _extractValue(lines, 'Severity') ?? 'N/A',
        };
      }).toList();

      // Build lab results list - matches labresultsSchema
      final labResultsList = data.labResultsList.map((result) {
        final lines = result.split('\n');
        return {
          'test_name': _extractValue(lines, 'Test Name') ?? 'N/A',
          'test_date': _extractValue(lines, 'Date of Test') ?? DateTime.now().toIso8601String(),
          'test_result': _extractValue(lines, 'Test Result') ?? 'N/A',
          'reference_range': _extractValue(lines, 'Reference Range') ?? 'N/A',
          'test_flag': _extractValue(lines, 'Flag') ?? 'N/A',
        };
      }).toList();

      // Build prescriptions list - matches prescriptionSchema
      final prescriptionsList = data.prescriptionsList.map((prescription) {
        final lines = prescription.split('\n');
        return {
          'medication_name': _extractValue(lines, 'Medication Name') ?? 'N/A',
          'dosage': _extractValue(lines, 'Dosage') ?? 'N/A',
          'quantity': int.tryParse(_extractValue(lines, 'Quantity') ?? '0') ?? 0,
          'date_prescribe': _extractValue(lines, 'Date of Prescribe') ?? DateTime.now().toIso8601String(),
          'prescribing_provider': _extractValue(lines, 'Prescribe By') ?? 'N/A',
          'frequency': 'As prescribed',
        };
      }).toList();

      // Call API with Maps
      final result = await PatientApiService.registerPatient(
        patient: patientData,
        visit: visitData.isNotEmpty ? visitData : null,
        vitalSigns: vitalSignsData.isNotEmpty ? vitalSignsData : null,
        medications: medicationsList.isNotEmpty ? medicationsList : null,
        medicalHistory: medicalHistoryList.isNotEmpty ? medicalHistoryList : null,
        allergies: allergiesList.isNotEmpty ? allergiesList : null,
        labResults: labResultsList.isNotEmpty ? labResultsList : null,
        prescriptions: prescriptionsList.isNotEmpty ? prescriptionsList : null,
      );

      setState(() => isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient saved successfully! ID: ${result['patientId']}'), backgroundColor: Colors.green),
        );
        MedicalData.resetAll();
        setState(() => currentPage = 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  String? _extractValue(List<String> lines, String key) {
    try {
      final line = lines.firstWhere((l) => l.contains(key), orElse: () => '');
      return line.split(':').length > 1 ? line.split(':')[1].trim() : null;
    } catch (e) {
      return null;
    }
  }

  // Part 1 Content
  Widget _buildPart1() {
    return Column(children: [
      _card("Patient Information", "", Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _patientInfo('Full Name', widget.patientData["Full Name"] ?? ''),
        _patientInfo('Birth Date', widget.patientData["Birth Date"] ?? ''),
        _patientInfo('Gender', widget.patientData["Gender"] ?? ''),
        _patientInfo('ID Number', widget.patientData["ID Number"] ?? ''),
      ]), LucideIcons.user),

      _card("Contact Information", "Type N/A if not applicable", Column(children: [
        _input("Email Address", 'email', hint: "e.g. juan@gmail.com"),
        _input("Home Address", 'homeAddress', hint: "e.g. 123 Mabini ST., Quezon City"),
        _input("Contact Number", 'contactNumber', hint: "+639 xxx xxx xxx"),
        _input("Emergency Contact Number", 'emergencyContact', hint: "+639 xxx xxx xxx"),
      ]), LucideIcons.phone),

      _card("Reason for Visit", "", Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: MedicalData.getController('reasonForVisit'),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Type something here...",
            hintStyle: TextStyle(fontSize: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(12),
          ),
          style: TextStyle(fontSize: 10),
        ),
        SizedBox(height: 20),
      ]), LucideIcons.stethoscope),

      _card("Vital Signs", "All fields are required", Column(children: [
        Row(children: [
          Expanded(child: _input("Body Temperature", 'bodyTemp', hint: "36.5°C – 37.5°C")),
          SizedBox(width: 16),
          Expanded(child: _input("Heart Pulse", 'heartPulse', hint: "60 - 100 bpm")),
        ]),
        Row(children: [
          Expanded(child: _input("Respiratory Rate", 'respiratoryRate', hint: "12 - 20 breaths/min")),
          SizedBox(width: 16),
          Expanded(child: _input("Blood Pressure", 'bloodPressure', hint: "120/80 mmHg")),
        ]),
      ]), LucideIcons.activity),
    ]);
  }

  // Part 2 Content
  Widget _buildPart2() {
    return Column(children: [
      _card("Patient Information", "", Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _patientInfo('Full Name', widget.patientData["Full Name"] ?? ''),
        _patientInfo('Birth Date', widget.patientData["Birth Date"] ?? ''),
        _patientInfo('Gender', widget.patientData["Gender"] ?? ''),
        _patientInfo('ID Number', widget.patientData["ID Number"] ?? ''),
      ]), LucideIcons.user),

      _card("Current Medication", "Type N/A if not applicable", Column(children: [
        Row(children: [
          Expanded(child: _input("Medication Name", 'medicationName', hint: "Medication Name")),
          SizedBox(width: 16),
          Expanded(child: _date("Date Started", data.dateStarted, (date) => setState(() => data.dateStarted = date))),
        ]),
        Row(children: [
          Expanded(child: _input("Dosage", 'dosage', hint: "Dosage")),
          SizedBox(width: 16),
          Expanded(child: _input("Frequency", 'frequency', hint: "Frequency")),
        ]),
        _addButton("Add", _addMedication),
        ...data.currentMedicationsList.asMap().entries.map((e) => _medicationItem(e.key)),
      ]), LucideIcons.pill),

      _card("Medical History", "Type N/A if not applicable", Column(children: [
        Row(children: [
          Expanded(child: _input("Condition Name", 'conditionName', hint: "Condition Name")),
          SizedBox(width: 16),
          Expanded(child: _date("Diagnose Date", data.diagnoseDate, (date) => setState(() => data.diagnoseDate = date))),
        ]),
        Row(children: [
          Expanded(child: _dropdown("Condition Type", data.selectedConditionType, conditionTypes, (value) => setState(() => data.selectedConditionType = value!))),
          SizedBox(width: 16),
          Expanded(child: _dropdown("Severity", data.selectedSeverity, severityOptions, (value) => setState(() => data.selectedSeverity = value!))),
        ]),
        Row(children: [
          Expanded(child: _dropdown("Condition Status", data.selectedConditionStatus, conditionStatusOptions, (value) => setState(() => data.selectedConditionStatus = value!))),
          SizedBox(width: 16),
          Expanded(child: _date("Resolution Date", data.revolutionDate, (date) => setState(() => data.revolutionDate = date))),
        ]),
        _addButton("Add", () => _addToList(data.medicalHistory, () => 'Condition Name: ${MedicalData.getController('conditionName').text}\nDiagnose Date: ${data.diagnoseDate!.toLocal().toString().split(' ')[0]}\nCondition Type: ${data.selectedConditionType}\nSeverity: ${data.selectedSeverity}\nCondition Status: ${data.selectedConditionStatus}${data.revolutionDate != null ? '\nResolution Date: ${data.revolutionDate!.toLocal().toString().split(' ')[0]}' : ''}', ['conditionName'], [data.diagnoseDate, data.selectedConditionType != 'Condition Type', data.selectedSeverity != 'Severity', data.selectedConditionStatus != 'Condition Status'])),
        ...data.medicalHistory.asMap().entries.map((e) => _listItem(e.value, e.key, data.medicalHistory)),
      ]), LucideIcons.heart),

      _card("Allergies", "Type N/A if not applicable", Column(children: [
        Row(children: [
          Expanded(child: _input("Allergy Name", 'allergyName', hint: "e.g seafood allergy")),
          SizedBox(width: 16),
          Expanded(child: _input("Allergy Type", 'allergyType', hint: "e.g Food, Medication etc.")),
        ]),
        Row(children: [
          Expanded(child: _input("Allergy Reaction", 'allergyReaction', hint: "e.g Difficulty breathing")),
          SizedBox(width: 16),
          Expanded(child: _dropdown("Severity", data.selectedAllergySeverity, severityOptions, (value) => setState(() => data.selectedAllergySeverity = value!))),
        ]),
        _addButton("Add", () => _addToList(data.allergiesList, () => 'Allergy Name: ${MedicalData.getController('allergyName').text}\nAllergy Type: ${MedicalData.getController('allergyType').text}\nAllergy Reaction: ${MedicalData.getController('allergyReaction').text}\nSeverity: ${data.selectedAllergySeverity}', ['allergyName', 'allergyType', 'allergyReaction'], [data.selectedAllergySeverity != 'Severity'])),
        ...data.allergiesList.asMap().entries.map((e) => _listItem(e.value, e.key, data.allergiesList)),
      ]), LucideIcons.dna),

      _card("Lab Result", "Type N/A if not applicable", Column(children: [
        _input("Test Name", 'testName', hint: "Test Name"),
        Row(children: [
          Expanded(child: _date("Date of Test", data.testDate, (date) => setState(() => data.testDate = date))),
          SizedBox(width: 16),
          Expanded(child: _input("Test Result", 'testResult', hint: "Test Result")),
        ]),
        Row(children: [
          Expanded(child: _input("Reference Range", 'referenceRange', hint: "e.g 40-60")),
          SizedBox(width: 16),
          Expanded(child: _dropdown("Flag", data.selectedFlag, flagOptions, (value) => setState(() => data.selectedFlag = value!))),
        ]),
        _addButton("Add", () => _addToList(data.labResultsList, () => 'Test Name: ${MedicalData.getController('testName').text}\nDate of Test: ${data.testDate!.toLocal().toString().split(' ')[0]}\nTest Result: ${MedicalData.getController('testResult').text}\nReference Range: ${MedicalData.getController('referenceRange').text}\nFlag: ${data.selectedFlag}', ['testName', 'testResult', 'referenceRange'], [data.testDate, data.selectedFlag != 'Flag'])),
        ...data.labResultsList.asMap().entries.map((e) => _listItem(e.value, e.key, data.labResultsList)),
      ]), LucideIcons.dna),

      _card("Prescription", "Type N/A if not applicable", Column(children: [
        _input("Medication Name", 'prescriptionMedicationName', hint: "Medication Name"),
        Row(children: [
          Expanded(child: _input("Dosage", 'prescriptionDosage', hint: "Dosage")),
          SizedBox(width: 16),
          Expanded(child: _input("Quantity", 'quantity', hint: "Quantity")),
        ]),
        Row(children: [
          Expanded(child: _date("Date of Prescribe", data.dateOfPrescribe, (date) => setState(() => data.dateOfPrescribe = date))),
          SizedBox(width: 16),
          Expanded(child: _input("Prescribe By", 'prescribeBy', hint: "Name of Provider")),
        ]),
        _addButton("Add", () => _addToList(data.prescriptionsList, () => 'Medication Name: ${MedicalData.getController('prescriptionMedicationName').text}\nDosage: ${MedicalData.getController('prescriptionDosage').text}\nQuantity: ${MedicalData.getController('quantity').text}\nDate of Prescribe: ${data.dateOfPrescribe!.toLocal().toString().split(' ')[0]}\nPrescribe By: ${MedicalData.getController('prescribeBy').text}', ['prescriptionMedicationName', 'prescriptionDosage', 'quantity', 'prescribeBy'], [data.dateOfPrescribe])),
        ...data.prescriptionsList.asMap().entries.map((e) => _listItem(e.value, e.key, data.prescriptionsList)),
      ]), LucideIcons.pill),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) { if (!didPop) Navigator.pop(context); },
      child: Scaffold(
        appBar: customAppBar("Medical Information", LucideIcons.file_plus, context),
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 20),
          Text("Medical Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Complete Patient Medical Profile", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          SizedBox(height: 8),
          Text("Page ${currentPage + 1} of 2", style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 20),
          
          // Display content based on current page
          currentPage == 0 ? _buildPart1() : _buildPart2(),

          SizedBox(height: 30),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: currentPage == 0 
            ? SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => currentPage = 1),
                  icon: Text("Next", style: TextStyle(fontSize: 16)),
                  label: Icon(LucideIcons.arrow_right, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            : Row(children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => setState(() => currentPage = 0),
                  icon: Icon(LucideIcons.arrow_left, size: 16),
                  label: Text("Previous", style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.symmetric(vertical: 12)),
                )),
                SizedBox(width: 16),
                Expanded(child: ElevatedButton(
                  onPressed: isLoading ? null : _saveToRecords,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.symmetric(vertical: 12)),
                  child: isLoading 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Text("Save to Records", style: TextStyle(fontSize: 14)),
                )),
              ])
          ),
          SizedBox(height: 30),
        ])),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 6, offset: const Offset(0, -3))]),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: index)), (route) => false),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.secondary,
            items: const [
              BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: "Dashboard"),
              BottomNavigationBarItem(icon: Icon(LucideIcons.camera), label: 'Scan ID'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.search), label: "Search"),
              BottomNavigationBarItem(icon: Icon(LucideIcons.bot), label: "Assistant"),
            ],
          ),
        ),
      ),
    );
  }
}