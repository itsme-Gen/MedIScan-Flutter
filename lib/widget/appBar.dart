import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';

AppBar reusableAppBar(String title  ,IconData preicon){
  return AppBar(
    title: Padding(padding: EdgeInsets.all(20),
      child: Row(
        children: [

          Icon(preicon,color: AppColors.primary,),
        
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10,),
            child: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),

        ],
      ),
    ),

    actions: [
      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(LucideIcons.circle_user,color: AppColors.primary,size: 30,),
      )
    ],
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: Colors.grey,
  );

}