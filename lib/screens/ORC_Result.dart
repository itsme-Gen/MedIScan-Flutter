// Updated ORC_Result.dart
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Medical_Information.dart';
import 'dart:io';

import 'package:medi_scan_mobile/widget/bottomNav.dart';

class OrcResultWithNav extends StatelessWidget {
  final File? imageFile;
  const OrcResultWithNav({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate back to Scan ID page when back button is pressed
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Bottomnav()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: OrcResult(imageFile: imageFile),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // ignore: deprecated_member_use
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 6, offset: const Offset(0, -3))],
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Bottomnav()),
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
}

class OrcResult extends StatefulWidget {
  final File? imageFile;
  const OrcResult({super.key, this.imageFile});

  @override
  State<OrcResult> createState() => _OrcResultState();
}

class _OrcResultState extends State<OrcResult> {
  final Map<String, String> extractedData = {
    "Full Name": "MARIA SANTOS DELA CRUZ",
    "ID Number": "ID-2024-001234", 
    "Address": "123 Rizal St., Makati City",
    "Emergency Contact": "JUAN DELA CRUZ (09171234567)",
    "Birth Date": "1985-03-15",
    "Blood Type": "O+"
  };

  Widget buildCard(Widget child) => Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  Widget buildButton(String text, Color color, VoidCallback onPressed, IconData icon) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );

  Widget buildTextField(String label, String value, IconData icon) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        if (["Full Name", "ID Number", "Birth Date"].contains(label)) Text(" *", style: TextStyle(color: Colors.red)),
      ]),
      SizedBox(height: 8),
      TextField(
        controller: TextEditingController(text: value),
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      SizedBox(height: 16),
    ],
  );

  IconData getIconForField(String label) {
    switch (label) {
      case "Full Name": return LucideIcons.user;
      case "ID Number": return LucideIcons.hash;
      case "Address": return LucideIcons.map_pin;
      case "Emergency Contact": return LucideIcons.phone;
      case "Birth Date": return LucideIcons.calendar;
      case "Blood Type": return LucideIcons.droplet;
      default: return LucideIcons.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(LucideIcons.file_text, color: AppColors.primary),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "ORC Result",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(LucideIcons.circle_user, color: AppColors.primary, size: 30),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("ORC Result", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Text("Review and edit the extracted information before proceeding", 
                   textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ),
            
            // Original Image & ORC Confidence
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Original Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("Scanned patient ID Document", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: widget.imageFile != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(widget.imageFile!, fit: BoxFit.cover))
                      : Center(child: Icon(LucideIcons.image, color: Colors.grey.shade400, size: 32)),
                ),
                SizedBox(height: 20),
                Text("ORC Confidence", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Row(children: [
                  Icon(LucideIcons.circle_check_big, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text("Processing completed successfully", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ]),
              ],
            )),
            
            // Extracted Information
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Extracted Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("Verify the accuracy of the extracted data", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                SizedBox(height: 20),
                ...extractedData.entries.map((e) => buildTextField(e.key, e.value, getIconForField(e.key))),
              ],
            )),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildButton("Scan Again", Colors.grey.shade600, () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Bottomnav()),
                      (route) => false,
                    );
                  }, LucideIcons.refresh_ccw),
                  SizedBox(height: 12),
                  buildButton("Search Records", AppColors.primary, () {
                    // Search Records functionality goes here
                  }, LucideIcons.search),
                  SizedBox(height: 12),
                  buildButton("Next", AppColors.secondary, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicalInformation(patientData: extractedData),
                      ),
                    );
                  }, LucideIcons.arrow_right),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Click "Search Records" to verify against existing patient database', 
                   textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}