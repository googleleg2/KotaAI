import 'package:flutter/material.dart';

class CustomerInformationForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController notesController;

  final bool delivery;

  final ValueChanged<bool> onDeliveryChanged;

  const CustomerInformationForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.notesController,
    required this.delivery,
    required this.onDeliveryChanged,
  });

  @override
  State<CustomerInformationForm> createState() =>
      _CustomerInformationFormState();
}

class _CustomerInformationFormState
    extends State<CustomerInformationForm> {

  InputDecoration decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          "Customer Information",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: widget.nameController,
          decoration: decoration(
            "Full Name",
            Icons.person,
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          decoration: decoration(
            "Phone Number",
            Icons.phone,
          ),
        ),

        const SizedBox(height: 20),

        SwitchListTile(
          value: widget.delivery,
          title: Text(
            widget.delivery
                ? "Delivery"
                : "Collection",
          ),
          onChanged:
              widget.onDeliveryChanged,
        ),

        if (widget.delivery) ...[

          const SizedBox(height: 15),

          TextField(
            controller:
                widget.addressController,
            maxLines: 3,
            decoration: decoration(
              "Delivery Address",
              Icons.location_on,
            ),
          ),
        ],

        const SizedBox(height: 15),

        TextField(
          controller: widget.notesController,
          maxLines: 3,
          decoration: decoration(
            "Special Instructions",
            Icons.notes,
          ),
        ),
      ],
    );
  }
}