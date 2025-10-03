import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar('Dashboard' ,(LucideIcons.house)),

      body: Center(
        child: Text("Ako dito pang pogi!",
          style: TextStyle(fontSize: 30, color: AppColors.primary),
        ),
      ),
    );
  }
}