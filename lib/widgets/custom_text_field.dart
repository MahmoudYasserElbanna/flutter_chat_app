import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    Key? key,
    required this.labelText,
    this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  final String? labelText;
  final Function(String)? onChanged;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: obscureText!,
        validator: (data) {
          if (data!.isEmpty) {
            return 'Please Enter a Value';
          } else if (data.length < 8) {
            return 'Use at Least 8 Characters';
          } // else if (!data.contains('@') && !data.contains('.com')) {
          //   return 'Missing @ or .com';
          // }
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(20),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
