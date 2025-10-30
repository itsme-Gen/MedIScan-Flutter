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
  List<String> medicalHistory = [];
  List<String> allergiesList = [];
  List<String> labResultsList = [];
  List<String> prescriptionsList = [];

  static TextEditingController getController(String key) =>
      _controllers.putIfAbsent(key, () => TextEditingController());
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

  @override
  void initState() {
    super.initState();
    data = widget.sharedData ?? MedicalData();
  }

  Widget _buildPart1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Part 1: Basic Medical Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildTextField("reasonForVisit", "Reason for Visit"),
          const SizedBox(height: 10),
          _buildTextField("bodyTemp", "Body Temperature (°C)"),
          const SizedBox(height: 10),
          _buildTextField("heartPulse", "Heart Pulse (bpm)"),
          const SizedBox(height: 10),
          _buildTextField("respiratoryRate", "Respiratory Rate (rpm)"),
          const SizedBox(height: 10),
          _buildTextField("bloodPressure", "Blood Pressure (mmHg)"),
          const SizedBox(height: 10),

          TextField(
            controller: MedicalData.getController("currentMedications"),
            decoration: const InputDecoration(
              labelText: "Current Medications",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  data.currentMedicationsList.add(value);
                  MedicalData.getController("currentMedications").clear();
                });
              }
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: data.currentMedicationsList
                .map((med) => Chip(
                      label: Text(med),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() => data.currentMedicationsList.remove(med));
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPart2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Part 2: Contact and Additional Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildTextField("homeAddress", "Home Address"),
          const SizedBox(height: 10),
          _buildTextField("email", "Email Address"),
          const SizedBox(height: 10),
          _buildTextField("contactNumber", "Contact Number"),
          const SizedBox(height: 10),
          _buildTextField("emergencyContact", "Emergency Contact Number"),
        ],
      ),
    );
  }

  Widget _buildTextField(String key, String label) {
    return TextField(
      controller: MedicalData.getController(key),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _saveToRecords() async {
    setState(() => isLoading = true);

    final patientInfo = {
      "patient": {
        "first_name": widget.patientData["First Name"],
        "middle_name": widget.patientData["Middle Name"],
        "last_name": widget.patientData["Last Name"],
        "id_number": widget.patientData["ID Number"],
        "date_of_birth": widget.patientData["Birth Date"],
        "gender": widget.patientData["Gender"],
        "contact_number": MedicalData.getController('contactNumber').text,
        "email_address": MedicalData.getController('email').text,
        "home_address": MedicalData.getController('homeAddress').text,
        "emergency_contact_number":
            MedicalData.getController('emergencyContact').text,
      },
      "visit": {
        "reason_for_visit": MedicalData.getController('reasonForVisit').text,
      },
      "vitalSigns": {
        "body_temperature": MedicalData.getController('bodyTemp').text,
        "heart_pulse": MedicalData.getController('heartPulse').text,
        "respiratory_rate": MedicalData.getController('respiratoryRate').text,
        "blood_pressure": MedicalData.getController('bloodPressure').text,
      },
      "medications": data.currentMedicationsList
          .map((m) => {"medication_name": m})
          .toList(),
    };

    final success = await PatientApi.registerPatient(patientInfo);
    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully saved to records!')),
      );
      MedicalData.resetAll();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: 0)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: customAppBar("Medical Information", LucideIcons.file_plus, context),
        backgroundColor: Colors.grey.shade50,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 20),
              const Text("Medical Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Complete Patient Medical Profile",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              const SizedBox(height: 8),
              Text("Page ${currentPage + 1} of 2",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),

              // Page switch
              currentPage == 0 ? _buildPart1() : _buildPart2(),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: currentPage == 0
                    ? SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() => currentPage = 1),
                          icon: const Text("Next", style: TextStyle(fontSize: 16)),
                          label: const Icon(LucideIcons.arrow_right, size: 18),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      )
                    : Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => currentPage = 0),
                            icon: const Icon(LucideIcons.arrow_left, size: 16),
                            label: const Text("Previous", style: TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _saveToRecords,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text("Save to Records",
                                    style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ]),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -3))
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Bottomnav(initialIndex: index)),
              (route) => false,
            ),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.secondary,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(LucideIcons.house), label: "Dashboard"),
              BottomNavigationBarItem(
                  icon: Icon(LucideIcons.camera), label: 'Scan ID'),
              BottomNavigationBarItem(
                  icon: Icon(LucideIcons.search), label: "Search"),
              BottomNavigationBarItem(
                  icon: Icon(LucideIcons.bot), label: "Assistant"),
            ],
          ),
        ),
      ),
    );
  }
}