import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String selectedRole = 'Select Role';
  final List<String> roles = ['Select Role', 'Doctor', 'Nurse', 'Medical Technician', 'Pharmacist', 'Administrator'];

  Widget buildTextField(String hint, {bool isEmail = false, bool allowSpaces = false}) {
    return TextField(
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      inputFormatters: allowSpaces ? [] : [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 11),
        prefixIcon: isEmail ? Icon(LucideIcons.mail, color: Colors.grey, size: 16) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      style: TextStyle(fontSize: 11),
    );
  }

  Widget buildPasswordField(String hint) {
    return TextField(
      obscureText: true,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 11),
        prefixIcon: Icon(LucideIcons.lock, color: Colors.grey, size: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      style: TextStyle(fontSize: 11),
    );
  }

  Widget buildLabel(String text) => Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(width: 8),
              Icon(LucideIcons.chevron_left, color: AppColors.primary, size: 18),
              SizedBox(width: 4),
              Text('Back', style: TextStyle(color: AppColors.primary, fontSize: 12)),
            ],
          ),
        ),
        leadingWidth: 80,
        title: Text('CREATE ACCOUNT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('First Name'), SizedBox(height: 4), buildTextField('First name', allowSpaces: true)])),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Middle Name'), SizedBox(height: 4), buildTextField('Middle name', allowSpaces: true)])),
                ],
              ),

              SizedBox(height: 14),
              buildLabel('Last Name'),
              SizedBox(height: 4),
              buildTextField('Last name', allowSpaces: true),

              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel('Role'),
                        SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          initialValue: selectedRole,
                          isExpanded: true,
                          style: TextStyle(fontSize: 11, color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role, style: TextStyle(fontSize: 11)))).toList(),
                          onChanged: (newValue) => setState(() => selectedRole = newValue!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Department'), SizedBox(height: 4), buildTextField('Department', allowSpaces: true)])),
                ],
              ),

              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('License Number'), SizedBox(height: 4), buildTextField('Professional license number', allowSpaces: true)])),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Hospital ID'), SizedBox(height: 4), buildTextField('Employee/Hospital ID', allowSpaces: true)])),
                ],
              ),

              SizedBox(height: 14),
              buildLabel('Email'),
              SizedBox(height: 4),
              buildTextField('Professional email', isEmail: true),

              SizedBox(height: 14),
              buildLabel('Password'),
              SizedBox(height: 4),
              buildPasswordField('Create password'),

              SizedBox(height: 14),
              buildLabel('Confirm password'),
              SizedBox(height: 4),
              buildPasswordField('Confirm password'),

              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('Create Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
