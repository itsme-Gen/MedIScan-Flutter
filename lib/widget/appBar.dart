import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/screens/Login.dart';

// Standard reusable app bar (for Dashboard, Search, Assistant, Scan ID)
AppBar reusableAppBar(String title, IconData preicon, BuildContext context){
  return AppBar(
    title: Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(preicon, color: AppColors.primary),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () => showProfilePopup(context),
          child: Icon(LucideIcons.circle_user, color: AppColors.primary, size: 30),
        ),
      )
    ],
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: Colors.grey,
  );
}

// Custom app bar for medical pages (without back button)
AppBar customAppBar(String title, IconData preicon, BuildContext context){
  return AppBar(
    automaticallyImplyLeading: false,
    title: Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(preicon, color: AppColors.primary),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () => showProfilePopup(context),
          child: Icon(LucideIcons.circle_user, color: AppColors.primary, size: 30),
        ),
      )
    ],
    backgroundColor: Colors.white,
    elevation: 2,
  );
}

// Centralized profile popup function - Now with Profile and Settings options
void showProfilePopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(2),
        child: Stack(
          children: [
            // Tap outside to close
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: 60,
              right: 15,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 180,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile option
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          // Add navigation to profile page here later
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile clicked')),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Row(
                            children: [
                              Icon(LucideIcons.user, size: 18, color: AppColors.primary),
                              SizedBox(width: 12),
                              Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Settings option
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Settings clicked')),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Row(
                            children: [
                              Icon(LucideIcons.settings, size: 18, color: AppColors.primary),
                              SizedBox(width: 12),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      Divider(height: 1, color: Colors.grey.shade300),
                      
                      // Logout option
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close profile popup
                          showLogoutConfirmation(context); // Show logout confirmation
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Row(
                            children: [
                              Icon(LucideIcons.log_out, size: 18, color: AppColors.primary),
                              SizedBox(width: 12),
                              Text(
                                "Log out",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Centralized logout confirmation function
void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
