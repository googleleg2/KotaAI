import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/paypal_service.dart';

import '../controllers/checkout_controller.dart';
import '../controllers/order_controller.dart';

import '../models/customer_order.dart';

import '../services/order_number_generator.dart';

import '../widgets/confirm_order_button.dart';
import '../widgets/customer_information_form.dart';
import '../widgets/order_summary.dart';

import '../../../models/cart_item.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
  });

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

  bool loading = false;



  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }



  bool validateForm() {

    if (nameController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter your name.",
          ),
        ),
      );

      return false;
    }


    if (phoneController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter your phone number.",
          ),
        ),
      );

      return false;
    }


    if (delivery &&
        addressController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a delivery address.",
          ),
        ),
      );

      return false;
    }


    return true;
  }





  Future<void> checkout() async {

    if (!validateForm()) return;


    final checkout =
        context.read<CheckoutController>();


    final order =
        checkout.order!;



    final customerOrder =
        CustomerOrder(

      orderNumber:
          const OrderNumberGenerator()
              .generate(),


      customerName:
          nameController.text.trim(),


      phone:
          phoneController.text.trim(),


      delivery:
          delivery,


      address:
          addressController.text.trim(),


      notes:
          notesController.text.trim(),


      items:
          List<CartItem>.from(
            order.items,
          ),


      subtotal:
          order.subtotal,


      discount:
          order.discount,


      deliveryFee:
          order.deliveryFee,


      total:
          order.total,


      paymentStatus:
          "Pending",


      paymentMethod:
          "PayPal",


      paypalOrderId:
          "",


      paypalCaptureId:
          "",


      createdAt:
          DateTime.now(),

    );



    try {

      setState(() {
        loading = true;
      });



      // 1. Save pending order
      await context
          .read<OrderController>()
          .createOrder(
            customerOrder,
          );



      // 2. Convert items for PayPal
      final paypalItems =
          customerOrder.items.map(
        (item) {

          return {

            "name":
                item.ingredient.name,


            "quantity":
                item.quantity,


            "price":
                item.ingredient.price,

          };

        },
      ).toList();




      // 3. Create PayPal order
      // and redirect customer
      await const PayPalService()
          .startCheckout(

        orderNumber:
            customerOrder.orderNumber,


        total:
            customerOrder.total,


        items:
            paypalItems,

      );


    } catch (e) {


      if (mounted) {

        setState(() {
          loading = false;
        });


        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
                Text(
                  e.toString(),
                ),
          ),

        );

      }

    }

  }





  @override
  Widget build(BuildContext context) {

    return Consumer<CheckoutController>(

      builder:
          (_, checkoutController, __) {


        final order =
            checkoutController.order;



        if (order == null) {

          return const Scaffold(

            body:
                Center(

              child:
                  Text(
                    "No Order Available",
                    style:
                        TextStyle(
                          fontSize: 22,
                        ),
                  ),

            ),

          );

        }




        return Scaffold(

          appBar:
              AppBar(

            centerTitle:
                true,

            title:
                const Text(
                  "Review Your Order",
                ),

          ),



          body:
              SafeArea(

            child:
                Padding(

              padding:
                  const EdgeInsets.all(
                    20,
                  ),


              child:
                  Column(

                children: [

                  Expanded(

                    child:
                        SingleChildScrollView(

                      child:
                          Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,


                        children: [


                          const Text(
                            "Order Summary",
                            style:
                                TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                          ),



                          const SizedBox(
                            height: 20,
                          ),



                          OrderSummary(
                            order:
                                order,
                          ),



                          const SizedBox(
                            height: 30,
                          ),



                          const Text(
                            "Items",
                            style:
                                TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                          ),



                          const SizedBox(
                            height: 15,
                          ),



                          ...order.items.map(

                            (item) => Card(

                              child:
                                  ListTile(

                                leading:
                                    const Icon(
                                      Icons.fastfood,
                                    ),


                                title:
                                    Text(
                                      item
                                          .ingredient
                                          .name,
                                    ),


                                subtitle:
                                    Text(
                                      "Qty ${item.quantity}",
                                    ),


                                trailing:
                                    Text(
                                      "R${item.subtotal.toStringAsFixed(2)}",
                                    ),

                              ),

                            ),

                          ),



                          const SizedBox(
                            height: 35,
                          ),




                          CustomerInformationForm(

                            nameController:
                                nameController,


                            phoneController:
                                phoneController,


                            addressController:
                                addressController,


                            notesController:
                                notesController,


                            delivery:
                                delivery,


                            onDeliveryChanged:
                                (value) {

                              setState(() {

                                delivery =
                                    value;

                              });

                            },

                          ),



                          const SizedBox(
                            height: 30,
                          ),




                          loading

                              ? const Center(

                                  child:
                                      CircularProgressIndicator(),

                                )


                              : ConfirmOrderButton(

                                  onPressed:
                                      checkout,

                                ),

                        ],

                      ),

                    ),

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