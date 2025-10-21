import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/api/register.dart';
import 'package:medi_scan_mobile/colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final RegisterService _registerService = RegisterService();
  
  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _hospitalIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String selectedRole = 'Select Role';
  String selectedGender = 'Male';
  bool _isLoading = false;
  
  final List<String> roles = ['Select Role', 'Doctor', 'Nurse', 'Medical Technician', 'Pharmacist', 'Administrator'];
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _departmentController.dispose();
    _licenseNumberController.dispose();
    _hospitalIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validation
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        selectedRole == 'Select Role' ||
        _departmentController.text.isEmpty ||
        _licenseNumberController.text.isEmpty ||
        _hospitalIdController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _registerService.registerUser(
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: selectedGender,
        role: selectedRole,
        department: _departmentController.text.trim(),
        licenseNumber: int.parse(_licenseNumberController.text.trim()),
        hospitalId: int.parse(_hospitalIdController.text.trim()),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result['status'] == 200 || result['status'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['body']['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buildTextField(String hint, TextEditingController controller, {bool isEmail = false, bool allowSpaces = false, bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : (isNumber ? TextInputType.number : TextInputType.text),
      inputFormatters: [
        if (!allowSpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
        if (isNumber) FilteringTextInputFormatter.digitsOnly,
      ],
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

  Widget buildPasswordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
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
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('First Name'), SizedBox(height: 4), buildTextField('First name', _firstNameController, allowSpaces: true)])),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Middle Name'), SizedBox(height: 4), buildTextField('Middle name', _middleNameController, allowSpaces: true)])),
                ],
              ),

              SizedBox(height: 14),
              buildLabel('Last Name'),
              SizedBox(height: 4),
              buildTextField('Last name', _lastNameController, allowSpaces: true),

              SizedBox(height: 14),
              buildLabel('Gender'),
              SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedGender,
                isExpanded: true,
                style: TextStyle(fontSize: 11, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                items: genders.map((gender) => DropdownMenuItem(value: gender, child: Text(gender, style: TextStyle(fontSize: 11)))).toList(),
                onChanged: (newValue) => setState(() => selectedGender = newValue!),
              ),

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
                          value: selectedRole,
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
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Department'), SizedBox(height: 4), buildTextField('Department', _departmentController, allowSpaces: true)])),
                ],
              ),

              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('License Number'), SizedBox(height: 4), buildTextField('Professional license number', _licenseNumberController, isNumber: true)])),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [buildLabel('Hospital ID'), SizedBox(height: 4), buildTextField('Employee/Hospital ID', _hospitalIdController, isNumber: true)])),
                ],
              ),

              SizedBox(height: 14),
              buildLabel('Email'),
              SizedBox(height: 4),
              buildTextField('Professional email', _emailController, isEmail: true),

              SizedBox(height: 14),
              buildLabel('Password'),
              SizedBox(height: 4),
              buildPasswordField('Create password', _passwordController),

              SizedBox(height: 14),
              buildLabel('Confirm password'),
              SizedBox(height: 4),
              buildPasswordField('Confirm password', _confirmPasswordController),

              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: _isLoading 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Create Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}