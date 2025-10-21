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
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final data = [
    {'accidents': 250, 'infectious': 180, 'chronic': 150, 'other': 320},
    {'accidents': 180, 'infectious': 120, 'chronic': 100, 'other': 200},
    {'accidents': 250, 'infectious': 150, 'chronic': 130, 'other': 300},
    {'accidents': 80, 'infectious': 60, 'chronic': 40, 'other': 120},
    {'accidents': 120, 'infectious': 80, 'chronic': 60, 'other': 160},
    {'accidents': 40, 'infectious': 30, 'chronic': 20, 'other': 80},
    {'accidents': 280, 'infectious': 200, 'chronic': 150, 'other': 350},
    {'accidents': 60, 'infectious': 40, 'chronic': 30, 'other': 100},
    {'accidents': 140, 'infectious': 100, 'chronic': 80, 'other': 180},
    {'accidents': 160, 'infectious': 120, 'chronic': 100, 'other': 200},
    {'accidents': 180, 'infectious': 140, 'chronic': 120, 'other': 220},
    {'accidents': 200, 'infectious': 160, 'chronic': 140, 'other': 240},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar('Dashboard', LucideIcons.house, context),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/doctor1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "Good Afternoon, Dr. Juan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Metrics Cards Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildMetricCard(
                    "Patient Scan Today",
                    "127",
                    "10/3/2025, Friday",
                    AppColors.cardBlueGradient,
                  ),
                  _buildMetricCard(
                    "Records Verified",
                    "98",
                    "10/3/2025, Friday",
                    AppColors.cardGreenGradient,
                  ),
                  _buildMetricCard(
                    "Newly Registered",
                    "15",
                    "10/3/2025, Friday",
                    AppColors.cardLightBlueGradient,
                  ),
                  _buildMetricCard(
                    "Pending Reviews",
                    "8",
                    "10/3/2025, Friday",
                    AppColors.cardOrangeGradient,
                  ),
                ],
              ),
            ),

            // Chart Section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Monthly Medical Cases Overview",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Number of patients by case type per month",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem("Accidents", AppColors.chartAccidents),
                      _buildLegendItem("Infectious Diseases", AppColors.chartInfectious),
                      _buildLegendItem("Chronic Illnesses", AppColors.chartChronic),
                      _buildLegendItem("Other Cases", AppColors.chartOther),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Scrollable Horizontal Bar Chart
                  SizedBox(
                    height: 420,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 670,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            Expanded(child: _buildBarChart()),
                            SizedBox(height: 16),
                            Text(
                              "Number of Patients",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String date, Gradient gradient) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    const maxValue = 1000.0;
    const chartWidth = 600.0;

    return Column(
      children: [
        // Bar chart rows
        ...data.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, int> monthData = entry.value;
          
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    months[index],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: chartWidth,
                  child: Row(
                    children: [
                      // Accidents
                      Container(
                        height: 20,
                        width: (monthData['accidents']! / maxValue) * chartWidth,
                        decoration: BoxDecoration(
                          color: AppColors.chartAccidents,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                          ),
                        ),
                      ),
                      // Infectious Diseases
                      Container(
                        height: 20,
                        width: (monthData['infectious']! / maxValue) * chartWidth,
                        color: AppColors.chartInfectious,
                      ),
                      // Chronic Illnesses
                      Container(
                        height: 20,
                        width: (monthData['chronic']! / maxValue) * chartWidth,
                        color: AppColors.chartChronic,
                      ),
                      // Other Cases
                      Container(
                        height: 20,
                        width: (monthData['other']! / maxValue) * chartWidth,
                        decoration: BoxDecoration(
                          color: AppColors.chartOther,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        
        SizedBox(height: 16),
        
        // X-axis scale
        Row(
          children: [
            SizedBox(width: 38),
            SizedBox(
              width: chartWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i <= 1000; i += 100)
                    Text(
                      "$i",
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}