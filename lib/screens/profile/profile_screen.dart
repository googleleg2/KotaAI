import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: const Center(

        child: Text(

          "Profile",

          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),

        ),

      ),

    );

  }
}