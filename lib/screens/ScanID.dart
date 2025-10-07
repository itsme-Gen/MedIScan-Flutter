import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/screens/ORC_Result.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Scanid extends StatefulWidget {
  const Scanid({super.key});

  @override
  State<Scanid> createState() => _ScanidState();
}

class _ScanidState extends State<Scanid> {
  File? imageFile;
  bool isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => imageFile = File(photo.path));
    }
  }

  Future<void> uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => imageFile = File(image.path));
    }
  }

  Future<void> processImage() async {
    setState(() => isProcessing = true);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() => isProcessing = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrcResultWithNav(imageFile: imageFile)),
      );
    }
  }

  Widget buildCard(Widget child) => Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool hasImage = imageFile != null;
    
    return Scaffold(
      appBar: reusableAppBar("Scan ID", LucideIcons.camera),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Scan Patient ID", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Capture or upload a patient identification\ndocument for verification", 
                 textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            
            // Capture Photo Section
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: Icon(LucideIcons.camera, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Capture Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Use your device camera or upload an\nexisting image", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ]),
                ]),
                
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: hasImage 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      )
                    : Center(child: Icon(LucideIcons.image, color: Colors.grey.shade400, size: 32)),
                ),
                
                SizedBox(height: 16),
                buildButton("Take a Photo", AppColors.primary, takePhoto, LucideIcons.camera),
                SizedBox(height: 8),
                buildButton("Upload Image", Colors.grey.shade400, uploadImage, LucideIcons.upload),
              ],
            )),
            
            // OCR Processing Section - Bigger container
            buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(12)),
                    child: Icon(LucideIcons.zap, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("OCR Processing", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Extract text data from the captured\nimage", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ]),
                ]),
                
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isProcessing 
                        ? CircularProgressIndicator(strokeWidth: 2)
                        : hasImage 
                          ? Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(LucideIcons.zap, color: Colors.green, size: 24),
                            )
                          : Icon(LucideIcons.info, color: Colors.blue, size: 24),
                      SizedBox(height: 12),
                      Text(
                        isProcessing ? "Processing..." : (hasImage ? "Ready to process" : "No image to process"),
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      if (hasImage && !isProcessing) ...[
                        SizedBox(height: 8),
                        Text("Click below to extract text from the image", 
                             style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
                
                if (hasImage && !isProcessing) ...[
                  SizedBox(height: 16),
                  buildButton("Process Image", Colors.green, processImage, LucideIcons.zap),
                ],
              ],
            )),
          ],
        ),
      ),
    );
  }
}
