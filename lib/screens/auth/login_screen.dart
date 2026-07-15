import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            const SizedBox(height: 40),

            TextField(

              decoration: InputDecoration(
                hintText: "Email",
              ),

            ),

            const SizedBox(height: 20),

            TextField(

              obscureText: true,

              decoration: InputDecoration(
                hintText: "Password",
              ),

            ),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {
                  context.go('/home');
                },

                child: const Text("LOGIN"),

              ),

            ),

          ],

        ),

      ),

    );

  }
}