import 'package:flutter/material.dart';

class DataWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final void Function() buttonPressCallback;

  const DataWidget({
    required this.controller,
    required this.buttonPressCallback,
    required this.hintText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: buttonPressCallback,
            style: TextButton.styleFrom(
              elevation: 0,
              minimumSize: const Size.fromHeight(56.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ).merge(
              ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    return states.contains(MaterialState.disabled) ? Colors.blueGrey : Colors.blue;
                  },
                ),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
