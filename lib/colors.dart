import 'package:flutter/material.dart';

class AppColors{
  static const Color primary = Color(0xFF1C6EA4);
  static const Color secondary = Color(0xFF33A1E0);
  
  // Card Gradient Colors for Dashboard Metric Cards
  static const Color cardBlue1 = Color(0xFF1C6EA4); // Patient Scan Today card - gradient start
  static const Color cardBlue2 = Color(0xFF2E86DE); // Patient Scan Today card - gradient end
  static const Color cardGreen1 = Color(0xFF00B894); // Records Verified card - gradient start
  static const Color cardGreen2 = Color(0xFF00CEC9); // Records Verified card - gradient end
  static const Color cardLightBlue1 = Color(0xFF0984E3); // Newly Registered card - gradient start
  static const Color cardLightBlue2 = Color(0xFF74B9FF); // Newly Registered card - gradient end
  static const Color cardOrange1 = Color(0xFFE17055); // Pending Reviews card - gradient start
  static const Color cardOrange2 = Color(0xFFFF7675); // Pending Reviews card - gradient end
  
  // Chart Colors for Bar Graph Categories
  static const Color chartAccidents = Color(0xFF1C6EA4); // Accidents category in bar chart
  static const Color chartInfectious = Color(0xFF00B894); // Infectious Diseases category in bar chart
  static const Color chartChronic = Color(0xFF0984E3); // Chronic Illnesses category in bar chart
  static const Color chartOther = Color(0xFFE17055); // Other Cases category in bar chart
  
  // Pre-defined Card Gradients for Dashboard Metric Cards
  static const LinearGradient cardBlueGradient = LinearGradient( // Patient Scan Today card background
    colors: [cardBlue1, cardBlue2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGreenGradient = LinearGradient( // Records Verified card background
    colors: [cardGreen1, cardGreen2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardLightBlueGradient = LinearGradient( // Newly Registered card background
    colors: [cardLightBlue1, cardLightBlue2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardOrangeGradient = LinearGradient( // Pending Reviews card background
    colors: [cardOrange1, cardOrange2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}