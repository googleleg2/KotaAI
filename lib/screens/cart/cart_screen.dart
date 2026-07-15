import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Cart"),
      ),

      body: const Center(

        child: Text(

          "Cart",

          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),

        ),

      ),

    );

  }
}