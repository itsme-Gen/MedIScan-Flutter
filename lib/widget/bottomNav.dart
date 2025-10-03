import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Assistant.dart';
import 'package:medi_scan_mobile/screens/Dashboard.dart';
import 'package:medi_scan_mobile/screens/ScanID.dart';
import 'package:medi_scan_mobile/screens/Search.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    Dashboard(),
    Scanid(),
    Search(),
    Assistant()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[currentIndex],
      ),

      // ✅ Wrap BottomNavigationBar inside a Container with BoxShadow
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // background of nav
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // shadow color
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, -3), // shadow upwards
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.camera),
              label: 'Scan ID',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.bot),
              label: "Assistant",
            ),
          ],
        ),
      ),
    );
  }
}
