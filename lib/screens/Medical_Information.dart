import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/screens/Medical_Information_Part2.dart';

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
  // ignore: avoid_function_literals_in_foreach_calls
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
          SizedBox(height: 20),
          
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

          SizedBox(height: 30),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalInformationPart2(patientData: widget.patientData, sharedData: data))),
              icon: Text("Next", style: TextStyle(fontSize: 16)),
              label: Icon(LucideIcons.arrow_right, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          )),
          SizedBox(height: 30),
        ])),
        bottomNavigationBar: Container(
          // ignore: deprecated_member_use
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