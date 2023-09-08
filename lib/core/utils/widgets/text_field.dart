import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  TextInputType? type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  Function? validate, // Make the validate function optional
  required String label,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  bool autofocus = false,
  TextInputType? keyboardType,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? type,
      obscureText: isPassword,
      enabled: isClickable,
      autofocus: autofocus,
      onFieldSubmitted: (value) {},
      onChanged: (value) {
        return onChange!(value);
      },
      onTap: () {
        onTap!();
      },
      validator: validate != null
          ? (value) => validate(value)
          : null, // Check if validate is provided
      decoration: InputDecoration(
        isDense: true,
        hintText: label,
        prefixIcon: prefix != null ? Icon(prefix) : null,
        hintStyle: const TextStyle(
          color: Color(0xFFA8A8A8),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

class InputTextWithHint extends StatelessWidget {
  final String text;
  final String hint;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType? type;
  final TextInputType? keyboardType; // Add this property
  final Function? validator; // Add this property

  const InputTextWithHint({
    Key? key,
    required this.text,
    required this.hint,
    this.type,
    this.suffixIcon,
    this.prefixIcon,
    required this.controller,
    this.keyboardType, // Initialize the property
    this.validator, // Initialize the property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * .83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 2),
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF525252),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          defaultFormField(
            controller: controller,
            type: type,
            keyboardType: keyboardType, // Pass keyboardType to defaultFormField
            onSubmit: null,
            onChange: null,
            onTap: null,
            autofocus: false,
            isPassword: false,
            validate:
                validator, // Pass the validator function to defaultFormField
            label: hint,
            suffix: suffixIcon,
            prefix: prefixIcon,
            suffixPressed: null,
            isClickable: true,
          ),
        ],
      ),
    );
  }
}
