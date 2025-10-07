import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';
import 'package:medi_scan_mobile/screens/Signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});


  //Login Authentacation goes here
  void navigateToDashbord (BuildContext context){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bottomnav()));
  }

  void navigateToSignup(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Icon(LucideIcons.stethoscope,size: 60, color: Colors.white,)
                ),

                Text("MediScan",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: AppColors.primary),
                ),

                Text("Medical record verification system",
                style: TextStyle(color: AppColors.secondary),
                ),
                
                SizedBox(height: 40),

                Align(
                  alignment: AlignmentGeometry.centerLeft,
                    child : Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                       child: Text("Welcome Back!",
                      style: TextStyle(fontSize: 20, color: AppColors.secondary),
                    ),
                  )
                ),

                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Login your Account!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppColors.primary),
                      ),
                    )
                  ),

                  SizedBox(height: 40),

                  Padding(padding: EdgeInsets.symmetric(horizontal:25),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(LucideIcons.user),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                    )),
                  ),
                  
                  SizedBox(height: 20),
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(LucideIcons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 30,),
                        child: ElevatedButton(onPressed: () {
                          navigateToDashbord(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white
                        ),
                        child: Padding(padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("Login", style:  TextStyle(fontSize: 24),),
                        )
                        ),
                      ),
                  ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                      GestureDetector(
                        onTap: () => navigateToSignup(context),
                        child: Text("Sign up hre",
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}