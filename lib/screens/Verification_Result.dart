import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';
import 'package:medi_scan_mobile/screens/Medical_Information.dart';
import 'package:medi_scan_mobile/api/verifyPatient.dart';

class VerificationResult extends StatefulWidget {
  final Map<String, String> patientData;
  const VerificationResult({super.key, required this.patientData});

  @override
  State<VerificationResult> createState() => _VerificationResultState();
}

class _VerificationResultState extends State<VerificationResult> {
  bool isPatientFound = false;
  bool isLoading = true;
  Map<String, dynamic>? foundPatientData;

  @override
  void initState() {
    super.initState();
    _verifyPatient();
  }

  Future<void> _verifyPatient() async {
    final idNumber = widget.patientData['ID Number']?.trim();

    if (idNumber == null || idNumber.isEmpty) {
      setState(() {
        isLoading = false;
        isPatientFound = false;
      });
      return;
    }

    try {
      final result = await PatientAPI.verifyPatient(idNumber);

      setState(() {
        isLoading = false;
        if (result['success'] == true && result['data']['success'] == true) {
          isPatientFound = true;
          foundPatientData = result['data']['patient'];
        } else {
          isPatientFound = false;
          foundPatientData = null;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isPatientFound = false;
        foundPatientData = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying patient: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _card(Widget child) => Container(
    margin: EdgeInsets.all(8), 
    padding: EdgeInsets.all(8), 
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  Widget _btn(String text, Color color, VoidCallback onPressed, {IconData? icon}) => Expanded(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 8), 
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14), 
                SizedBox(width: 6), 
                Text(text, style: TextStyle(fontSize: 12)), 
              ],
            )
          : Text(text, style: TextStyle(fontSize: 12)), 
    ),
  );

  Widget _patientInfo(String value, String label, IconData icon) => Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600), 
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
              Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)), 
            ],
          ),
        ],
      ),
      SizedBox(height: 8), 
    ],
  );

  String get fullName => "${widget.patientData['First Name']} ${widget.patientData['Middle Name']} ${widget.patientData['Last Name']}".trim();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: customAppBar("Verification Result", LucideIcons.shield_check, context),
        backgroundColor: Colors.grey.shade50,
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      "Verifying patient...",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12), 
              Text("Patient Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
              SizedBox(height: 4), 
              Text("Patient Records Search Completed", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), 
              SizedBox(height: 12), 

              // Patient Verification Section
              _card(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isPatientFound ? LucideIcons.circle_check : LucideIcons.circle_x,
                                color: isPatientFound ? Colors.green : Colors.orange,
                                size: 16
                              ),
                              SizedBox(width: 6),
                              Text(
                                isPatientFound ? "Patient Record Found" : "No Match Found", 
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            isPatientFound 
                                ? "Existing patient record has been located and verified"
                                : "This patient is not in our database. Registration required", 
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPatientFound ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        border: isPatientFound ? null : Border.all(color: Colors.black),
                      ),
                      child: Text(
                        isPatientFound ? "Existing Patient" : "New Patient",
                        style: TextStyle(
                          color: isPatientFound ? Colors.white : Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scanned Information Section 
              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Scanned Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 4), 
                  Text("Data extracted from the ID document.", style: TextStyle(color: Colors.grey.shade600, fontSize: 10)), 
                  SizedBox(height: 8), 
                  _patientInfo(fullName, "Full Name", LucideIcons.user),
                  _patientInfo(widget.patientData['ID Number'] ?? '', "ID Number", LucideIcons.id_card),
                  _patientInfo(widget.patientData['Birth Date'] ?? '', "Birth Date", LucideIcons.calendar),
                  _patientInfo(widget.patientData['Gender'] ?? '', "Gender", LucideIcons.venus_and_mars),
                ],
              )),

              // Patient Summary or Registration Required Section
              if (isPatientFound && foundPatientData != null) 
                _card(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patient Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), 
                    SizedBox(height: 4), 
                    Text("Overview of existing patient record.", style: TextStyle(color: Colors.grey.shade600, fontSize: 10)), 
                    SizedBox(height: 8), 
                    
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8), 
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6), 
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(LucideIcons.circle_check, color: Colors.green, size: 14), 
                              SizedBox(width: 6), 
                              Text("Patient Verified", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green.shade800)),
                            ],
                          ),
                          SizedBox(height: 2), 
                          Text("Patient record successfully matched and verified", style: TextStyle(color: Colors.green.shade700, fontSize: 10)), 
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 8), 
                    
                    _buildConditionRow("Patient ID:", foundPatientData!['_id']?.toString().substring(0, 8) ?? 'N/A'),
                    _buildConditionRow("Full Name:", "${foundPatientData!['first_name']} ${foundPatientData!['middle_name'] ?? ''} ${foundPatientData!['last_name']}".trim()),
                    _buildConditionRow("ID Number:", foundPatientData!['id_number'] ?? 'N/A'),
                    _buildConditionRow("Birth Date:", foundPatientData!['date_of_birth'] ?? 'N/A'),
                    _buildConditionRow("Gender:", foundPatientData!['gender'] ?? 'N/A'),
                  ],
                ))
              else
                _card(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Registration Required", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 4),
                    Text("Complete registration for new patient.", style: TextStyle(color: Colors.grey.shade600, fontSize: 10)), 
                    SizedBox(height: 8), 
                    
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8), 
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade50,
                        borderRadius: BorderRadius.circular(6), 
                        border: Border.all(color: Colors.yellow.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(LucideIcons.triangle_alert, color: Colors.yellow.shade700, size: 14), 
                              SizedBox(width: 6), 
                              Text("New Patient Registration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.yellow.shade800)), 
                            ],
                          ),
                          SizedBox(height: 2), 
                          Text("This patient is not found in our system. Please proceed to new patient registration", style: TextStyle(color: Colors.yellow.shade700, fontSize: 10)), 
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 8), 
                    
                    Text("Next Steps:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)), 
                    SizedBox(height: 4), 
                    Text("• Complete the medical form", style: TextStyle(fontSize: 10, color: Colors.grey.shade700)), 
                    Text("• Verify insurance information", style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                    Text("• Setup emergency contacts", style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                    Text("• Schedule initial consultation", style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                  ],
                )),

              // Action Buttons
              Padding(
                padding: EdgeInsets.all(8), 
                child: Row(
                  children: [
                    _btn("Scan Again", Colors.grey.shade600, () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: 1)),
                        (route) => false,
                      );
                    }, icon: LucideIcons.refresh_ccw),
                    SizedBox(width: 8), 
                    _btn(
                      isPatientFound ? "View Full Medical Record" : "Register New Patient",
                      isPatientFound ? AppColors.primary : AppColors.secondary,
                      () {
                        final patientDataForMedical = {
                          "Full Name": fullName,
                          "ID Number": widget.patientData['ID Number'] ?? '',
                          "Birth Date": widget.patientData['Birth Date'] ?? '',
                          "Gender": widget.patientData['Gender'] ?? '',
                        };
                        
                        MedicalData.resetAll();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicalInformation(patientData: patientDataForMedical),
                          ),
                        );
                      },
                      icon: isPatientFound ? null : LucideIcons.plus,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12), 
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 6, offset: const Offset(0, -3))],
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: index)),
                (route) => false,
              );
            },
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

  Widget _buildConditionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)), 
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}