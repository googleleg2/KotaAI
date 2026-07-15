import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Checkout"),
      ),

      body: const Center(

        child: Text(

          "Checkout",

          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),

        ),

      ),

    );

  }
}