import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/checkout_controller.dart';
import '../widgets/confirm_order_button.dart';
import '../widgets/customer_information_form.dart';
import '../widgets/order_summary.dart';

// import 'package:provider/provider.dart';

import '../models/customer_order.dart';
import '../screens/order_confirmation_screen.dart';
import '../services/order_number_generator.dart';
import '../controllers/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController notesController =
      TextEditingController();

  bool delivery = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (_, checkout, __) {

        final order = checkout.order;

        if (order == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "No Order Available",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Review Your Order",
            ),
            centerTitle: true,
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          OrderSummary(
                            order: order,
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          ...order.items.map(
                            (item) => Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.fastfood,
                                ),
                                title: Text(
                                  item.ingredient.name,
                                ),
                                trailing: Text(
                                  "R${item.subtotal.toStringAsFixed(2)}",
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          CustomerInformationForm(
                            nameController:
                                nameController,

                            phoneController:
                                phoneController,

                            addressController:
                                addressController,

                            notesController:
                                notesController,

                            delivery: delivery,

                            onDeliveryChanged:
                                (value) {
                              setState(() {
                                delivery = value;
                              });
                            },
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  ConfirmOrderButton(
                    onPressed: () {

  if (nameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter your name."),
      ),
    );
    return;
  }

  if (phoneController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter your phone number."),
      ),
    );
    return;
  }

  if (delivery &&
      addressController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Please enter a delivery address.",
        ),
      ),
    );
    return;
  }

  final customerOrder = CustomerOrder(

    orderNumber:
        const OrderNumberGenerator().generate(),

    customerName:
        nameController.text.trim(),

    phone:
        phoneController.text.trim(),

    delivery: delivery,

    address:
        addressController.text.trim(),

    notes:
        notesController.text.trim(),

    items: order.items,

    subtotal: order.subtotal,

    discount: order.discount,

    deliveryFee: order.deliveryFee,

    total: order.total,

    createdAt: DateTime.now(),
  );

  context
      .read<OrderController>()
      .createOrder(customerOrder);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          OrderConfirmationScreen(
        order: customerOrder,
      ),
    ),
  );
},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}