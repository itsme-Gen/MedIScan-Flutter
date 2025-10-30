import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Medical_Information.dart';
import 'package:medi_scan_mobile/screens/Verification_Result.dart';
import 'dart:io';
import 'package:medi_scan_mobile/widget/bottomNav.dart';

class OrcResultWithNav extends StatelessWidget {
  final File? imageFile;
  final Map<String, dynamic>? result;
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
          ocrResult: result,
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
  final Map<String, dynamic>? ocrResult;

  const OrcResult({super.key, this.imageFile, this.ocrResult});

  @override
  State<OrcResult> createState() => _OrcResultState();
}

class _OrcResultState extends State<OrcResult> {
  late Map<String, String> extractedData;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    final ocr = widget.ocrResult ?? {};

    extractedData = {
      "First Name": ocr["first_name"] ?? "",
      "Middle Name": ocr["middle_name"] ?? "",
      "Last Name": ocr["last_name"] ?? "",
      "ID Number": ocr["id_number"] ?? "",
      "Birth Date": ocr["date_of_birth"] ?? "",
      "Gender": ocr["gender"] ?? "",
    };
  }

  void _navigateToVerification() {
    // Validate required fields
    final idNumber = extractedData["ID Number"]?.trim();
    
    if (idNumber == null || idNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID Number is required to search records'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Navigate to Verification Result screen (API call happens there)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationResult(patientData: extractedData),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
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
          readOnly: !isEditing,
          onChanged: (newValue) {
            extractedData[label] = newValue;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey.shade100,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildGenderSelector(String label, String value, IconData icon) {
    String? normalizedValue;
    if (value.isNotEmpty) {
      String lowerValue = value.toLowerCase();
      if (lowerValue.contains('male') && !lowerValue.contains('female')) {
        normalizedValue = "Male";
      } else if (lowerValue.contains('female')) {
        normalizedValue = "Female";
      } else if (["Male", "Female"].contains(value)) {
        normalizedValue = value;
      }
    }

    String hintText = (value.isNotEmpty && normalizedValue == null) 
        ? value 
        : "Select gender";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ]),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: normalizedValue,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey.shade100,
          ),
          hint: Text(hintText, style: TextStyle(fontSize: 14, color: Colors.black87)),
          style: TextStyle(fontSize: 14, color: Colors.black),
          items: ["Male", "Female"].map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: isEditing
              ? (String? newValue) {
                  setState(() {
                    extractedData["Gender"] = newValue ?? "";
                  });
                }
              : null,
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

            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Extracted Information",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Verify the accuracy of the extracted data",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            _showSuccessSnackBar('Changes saved successfully');
                          }
                          isEditing = !isEditing;
                        });
                      },
                      icon:Icon(isEditing ? LucideIcons.save : Icons.edit, size: 16),
                      label: Text(isEditing ? "Save" : "Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEditing
                            ? AppColors.secondary
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ...extractedData.entries.map((e) {
                  if (e.key == "Gender") {
                    return buildGenderSelector(
                        e.key, e.value, getIconForField(e.key));
                  } else {
                    return buildTextField(
                        e.key, e.value, getIconForField(e.key));
                  }
                }),
              ],
            )),

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
                  buildButton("Search Records", AppColors.primary,
                      _navigateToVerification, LucideIcons.search),
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