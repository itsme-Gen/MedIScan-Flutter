import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';

class Scanid extends StatefulWidget {
  const Scanid({super.key});

  @override
  State<Scanid> createState() => _ScanidState();
}

class _ScanidState extends State<Scanid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar("Scan ID", LucideIcons.camera),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
           Text("Scan Id UI Goes here for Myca,It should be interactive pakigawa nadin yong sign up from pati yong form after e scan ng ID patulong ka nalang"),
             
          ]
        ),
      ),
    );
  }
}