import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Kota AI"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(

              "Build Your Perfect Kota",

              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),

            ),

            const SizedBox(height: 25),

            Card(

              child: SizedBox(

                height: 220,

                child: Center(

                  child: Icon(
                    Icons.lunch_dining,
                    color: AppColors.primary,
                    size: 120,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {
                  context.go('/builder');
                },

                child: const Text("BUILD MY KOTA"),

              ),

            ),

          ],

        ),

      ),

    );

  }
}