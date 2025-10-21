import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Medical_Information.dart';
import 'dart:io';
import 'package:medi_scan_mobile/widget/bottomNav.dart';

class OrcResultWithNav extends StatelessWidget {
  final File? imageFile;
  final Map<String, dynamic>? result; // 👈 result from OCR API
  final double? confidence;

  const OrcResultWithNav({
    Key? key,
    this.imageFile,
    this.result,
    this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: 1)),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: OrcResult(
          imageFile: imageFile,
          ocrResult: result, // 👈 Pass the extracted OCR data here
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, -3),
              )
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Bottomnav(initialIndex: index)),
                (route) => false,
              );
            },
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

class OrcResult extends StatefulWidget {
  final File? imageFile;
  final Map<String, dynamic>? ocrResult; // 👈 Add OCR result map

  const OrcResult({super.key, this.imageFile, this.ocrResult});

  @override
  State<OrcResult> createState() => _OrcResultState();
}

class _OrcResultState extends State<OrcResult> {
  late Map<String, String> extractedData;

  @override
  void initState() {
    super.initState();

    // 👇 Initialize extractedData from OCR result or fallback empty values
    final ocr = widget.ocrResult ?? {};

    extractedData = {
      "First Name": ocr["first_name"] ?? "",
      "Middle Name": ocr["middle_name"] ?? "",
      "Last Name": ocr["last_name"] ?? "",
      "ID Number": ocr["id_number"] ?? "",
      "Birth Date": ocr["birth_date"] ?? "",
      "Gender": ocr["gender"] ?? "",
    };
  }

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

  Widget buildButton(
          String text, Color color, VoidCallback onPressed, IconData icon) =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );

  Widget buildTextField(String label, String value, IconData icon) {
    final controller = TextEditingController(text: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          if (["First Name", "Last Name", "ID Number", "Birth Date"]
              .contains(label))
            Text(" *", style: TextStyle(color: Colors.red)),
        ]),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          onChanged: (newValue) {
            extractedData[label] = newValue; // 🔁 Keep map updated
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  IconData getIconForField(String label) {
    switch (label) {
      case "First Name":
      case "Middle Name":
      case "Last Name":
        return LucideIcons.user;
      case "ID Number":
        return LucideIcons.hash;
      case "Birth Date":
        return LucideIcons.calendar;
      case "Gender":
        return LucideIcons.user_check;
      default:
        return LucideIcons.file_text;
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
                  "OCR Result",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(LucideIcons.circle_user,
                color: AppColors.primary, size: 30),
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
            Text("OCR Result",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Text(
                "Review and edit the extracted information before proceeding",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),

            // Image preview and confidence
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Original Image",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("Scanned patient ID document",
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(widget.imageFile!,
                              fit: BoxFit.cover))
                      : Center(
                          child: Icon(LucideIcons.image,
                              color: Colors.grey.shade400, size: 32)),
                ),
                SizedBox(height: 20),
                Text("OCR Confidence",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Row(children: [
                  Icon(LucideIcons.circle_check_big,
                      color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text("Processing completed successfully",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ]),
              ],
            )),

            // Extracted Information
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Extracted Information",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("Verify the accuracy of the extracted data",
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                SizedBox(height: 20),
                ...extractedData.entries.map(
                    (e) => buildTextField(e.key, e.value, getIconForField(e.key))),
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
                      MaterialPageRoute(
                          builder: (context) => Bottomnav(initialIndex: 1)),
                      (route) => false,
                    );
                  }, LucideIcons.refresh_ccw),
                  SizedBox(height: 12),
                  buildButton("Search Records", AppColors.primary, () {
                    // Add search record functionality
                  }, LucideIcons.search),
                  SizedBox(height: 12),
                  buildButton("Next", AppColors.secondary, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MedicalInformation(patientData: extractedData),
                      ),
                    );
                  }, LucideIcons.arrow_right),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Click "Search Records" to verify against existing patient database',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
