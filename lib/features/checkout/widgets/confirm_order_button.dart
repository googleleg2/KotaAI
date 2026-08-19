import 'package:flutter/material.dart';

class ConfirmOrderButton extends StatefulWidget {
  final Future<void> Function() onPressed;

  const ConfirmOrderButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<ConfirmOrderButton> createState() =>
      _ConfirmOrderButtonState();
}


class _ConfirmOrderButtonState
    extends State<ConfirmOrderButton> {

  bool _loading = false;


  Future<void> _handlePressed() async {

    if (_loading) return;


    setState(() {
      _loading = true;
    });


    try {

      await widget.onPressed();

    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

    }
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(

        onPressed:
            _loading
                ? null
                : _handlePressed,


        child: _loading

            ? const SizedBox(
                height: 22,
                width: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )

            : const Text(
                "Checkout",
              ),
      ),
    );
  }
}