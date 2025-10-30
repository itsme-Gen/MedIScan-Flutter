import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Verification_Result.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: 1)),
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
}

class OrcResult extends StatefulWidget {
  final File? imageFile;
  const OrcResult({super.key, this.imageFile});

  @override
  State<OrcResult> createState() => _OrcResultState();
}

class _OrcResultState extends State<OrcResult> {
  bool isEditing = false;
  late Map<String, TextEditingController> controllers;
  
  final Map<String, String> _defaultData = {
    "First Name": "MARIA",
    "Middle Name": "SANTOS", 
    "Last Name": "DELA CRUZ",
    "ID Number": "1234-5678-9101-1213",
    "Birth Date": "1985-03-15",
    "Gender": "Female"
  };

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    controllers = {};
    _defaultData.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });
  }

  Widget _card(Widget child) => Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  Widget _editBtn() => OutlinedButton.icon(
    onPressed: () {
      setState(() {
        isEditing = !isEditing; 
      });
    },
    icon: Icon(
      isEditing ? LucideIcons.file_pen : LucideIcons.file_pen, 
      size: 12, 
      color: Colors.black
    ),
    label: Text(
      isEditing ? "Save" : "Edit", 
      style: TextStyle(fontSize: 10, color: Colors.black)
    ),
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );

  Widget _field(String label, String key, IconData icon) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
      ]),
      SizedBox(height: 4),
      TextField(
        controller: controllers[key],
        readOnly: !isEditing,
        style: TextStyle(
          fontSize: 10,
          color: isEditing ? Colors.black : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isEditing ? Colors.grey.shade300 : Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isEditing ? Colors.grey.shade300 : Colors.grey.shade200,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.grey.shade50,
        ),
      ),
      SizedBox(height: 8),
    ],
  );

  IconData _getIcon(String label) {
    const icons = {
      "First Name": LucideIcons.user,
      "Middle Name": LucideIcons.user,
      "Last Name": LucideIcons.user,
      "ID Number": LucideIcons.id_card,
      "Birth Date": LucideIcons.calendar,
      "Gender": LucideIcons.venus_and_mars,
    };
    return icons[label] ?? LucideIcons.user;
  }

  Map<String, String> _getCurrentData() {
    Map<String, String> currentData = {};
    controllers.forEach((key, controller) {
      currentData[key] = controller.text;
    });
    return currentData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("ORC Result", LucideIcons.file_text, context),
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
            
            _card(Column(
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
            
            _card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Extracted Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Verify the accuracy of the extracted data", style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                      ],
                    ),
                    _editBtn(),
                  ],
                ),
                SizedBox(height: 12),
                ..._getCurrentData().keys.map((key) => _field(key, key, _getIcon(key))),
              ],
            )),
            
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: 1)),
                          (route) => false,
                        );
                      },
                      icon: Icon(LucideIcons.refresh_ccw, size: 14),
                      label: Text("Scan Again", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationResult(patientData: _getCurrentData()),
                          ),
                        );
                      },
                      icon: Icon(LucideIcons.search, size: 14),
                      label: Text("Search Records", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
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