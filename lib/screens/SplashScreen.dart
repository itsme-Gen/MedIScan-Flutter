import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentStep = 0; 

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() {
    // Show logo only
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          currentStep = 1; // Show logo + description
        });
      }
    });

    // Show logo + description
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          currentStep = 2; // Go to login
        });
        _goToLogin();
      }
    });
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        LucideIcons.stethoscope,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      "MediScan",
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      "Medical record verification system",
      style: TextStyle(
        color: AppColors.secondary,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo 
              _buildLogo(),
              
              SizedBox(height: 20),
              
              // App name
              _buildAppName(),
              
              // Description (only visible in showing logo only)
              if (currentStep >= 1) ...[
                SizedBox(height: 10),
                _buildDescription(),
              ],
              
              // Loading indicator 
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}